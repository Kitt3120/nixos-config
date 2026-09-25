{ config, ... }:

{
  config = {
    sops.secrets = {
      "wireguard/ip" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };
      "wireguard/publicKey" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };
      "wireguard/endpoint" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };
      "wireguard/allowedIPs/localIP" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };
      "wireguard/allowedIPs/vpnIP" = {
        sopsFile = config.settings.sops.device-secrets;
        neededForUsers = true;
      };
    };

    networking.wireguard.interfaces = {
      MrMeeseeks = {
        privateKeyFile = "/etc/wireguard/key";
        generatePrivateKeyFile = true;

        ips = [ "$(cat ${config.sops.secrets."wireguard/ip".path})" ];
        peers = [
          {
            name = "MrMeeseeks-peer";
            endpoint = "$(cat ${config.sops.secrets."wireguard/endpoint".path})";
            publicKey = "$(cat ${config.sops.secrets."wireguard/publicKey".path})";
            allowedIPs = [
              "$(cat ${config.sops.secrets."wireguard/allowedIPs/localIP".path})"
              "$(cat ${config.sops.secrets."wireguard/allowedIPs/vpnIP".path})"
            ];
            dynamicEndpointRefreshSeconds = 30;
            dynamicEndpointRefreshRestartSeconds = 30;
          }
        ];
      };
    };
  };
}
