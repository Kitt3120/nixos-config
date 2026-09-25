{ config, lib, ... }:

let
  cfg = config.settings.networking.wireguard.interfaces;

  secretAttrs = {
    sopsFile = config.settings.sops.device-secrets;
    neededForUsers = true;
  };

  # Each interface/peer needs a static Nix name so its secrets can be registered at eval time;
  # everything else (address/allowed-IP counts) is read as a single comma-separated secret at runtime.
  secretEntries = lib.flatten (
    lib.mapAttrsToList (
      ifaceName: ifaceCfg:
      [
        {
          name = "wireguard/${ifaceName}/addresses";
          value = secretAttrs;
        }
      ]
      ++ lib.flatten (
        lib.mapAttrsToList (
          peerName: _peerCfg:
          let
            base = "wireguard/${ifaceName}/peers/${peerName}";
          in
          [
            {
              name = "${base}/publicKey";
              value = secretAttrs;
            }
            {
              name = "${base}/endpoint";
              value = secretAttrs;
            }
            {
              name = "${base}/allowedIPs";
              value = secretAttrs;
            }
          ]
        ) ifaceCfg.peers
      )
    ) cfg
  );
in
{
  options.settings.networking.wireguard.interfaces = lib.mkOption {
    default = { };
    description = "Data-driven WireGuard interfaces backed by SOPS secrets.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          peers = lib.mkOption {
            default = { };
            description = "Peers for this interface, keyed by peer name.";
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  dynamicEndpointRefreshSeconds = lib.mkOption {
                    type = lib.types.int;
                    default = 30;
                  };

                  dynamicEndpointRefreshRestartSeconds = lib.mkOption {
                    type = lib.types.int;
                    default = 30;
                  };
                };
              }
            );
          };
        };
      }
    );
  };

  config = {
    sops.secrets = lib.listToAttrs secretEntries;

    networking.wireguard.interfaces = lib.mapAttrs (ifaceName: ifaceCfg: {
      privateKeyFile = "/etc/wireguard/${ifaceName}-key";
      generatePrivateKeyFile = true;

      # Disabled because it can only add one prefix per `peer.allowedIPs` list entry, and our
      # entries are single comma-joined secrets; routes for allowed IPs are added in postSetup instead.
      allowedIPsAsRoutes = false;

      # `ips` requires each address as its own list element, so addresses (an arbitrary-length,
      # comma-separated secret) are added via a runtime loop instead.
      # `read` from a here-string (rather than directly from the secret file) so a missing
      # trailing newline doesn't make `read` fail under the unit script's `set -e`.
      postSetup = ''
        IFS=',' read -ra addresses <<< "$(cat ${
          config.sops.secrets."wireguard/${ifaceName}/addresses".path
        })"
        for address in "''${addresses[@]}"; do
          ip address add "$address" dev ${ifaceName}
        done

        ${lib.concatMapStringsSep "\n" (peerName: ''
          IFS=',' read -ra allowedIPs <<< "$(cat ${
            config.sops.secrets."wireguard/${ifaceName}/peers/${peerName}/allowedIPs".path
          })"
          for allowedIP in "''${allowedIPs[@]}"; do
            ip route replace "$allowedIP" dev ${ifaceName}
          done
        '') (builtins.attrNames ifaceCfg.peers)}
      '';

      peers = lib.mapAttrsToList (peerName: peerCfg: {
        name = "${ifaceName}-${peerName}";
        endpoint = "$(cat ${config.sops.secrets."wireguard/${ifaceName}/peers/${peerName}/endpoint".path})";
        publicKey = "$(cat ${
          config.sops.secrets."wireguard/${ifaceName}/peers/${peerName}/publicKey".path
        })";
        allowedIPs = [
          "$(cat ${config.sops.secrets."wireguard/${ifaceName}/peers/${peerName}/allowedIPs".path})"
        ];
        inherit (peerCfg) dynamicEndpointRefreshSeconds dynamicEndpointRefreshRestartSeconds;
      }) ifaceCfg.peers;
    }) cfg;
  };
}
