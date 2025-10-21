{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  comin = config.services.comin.package;
  ripgrep = pkgs.ripgrep;
  coreutils = pkgs.coreutils;
  systemd = pkgs.systemd;
  script-name = "comin-reboot-if-needed";
  rebootScriptDerivation = (
    pkgs.writeShellScriptBin script-name ''
      if ${comin}/bin/comin status | ${ripgrep}/bin/rg -q 'Need to reboot: yes'; then
        if ! ${coreutils}/bin/sleep 5; then
          echo "Warning: sleep failed, proceeding to reboot anyway" >&2
        fi
        ${systemd}/bin/systemctl reboot
      fi
    ''
  );
  rebootScript = "${rebootScriptDerivation}/bin/${script-name}";
in
{
  imports = [ inputs.comin.nixosModules.comin ];

  options.settings.comin = {
    autoReboot = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to automatically reboot the system after applying updates, if necessary.";
    };

    remotes = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "URL of the remote Git repository to sync with.";
              };

              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the remote to track.";
              };

              branch = lib.mkOption {
                type = lib.types.str;
                description = "Name of the branch to track.";
              };

              pollInterval = lib.mkOption {
                type = lib.types.int;
                description = "Interval (seconds) between polling this remote for changes.";
              };
            };
          }
        )
      );
      description = "List of comin remotes to track.";
    };
  };

  config = {
    services.comin = {
      enable = true;
      postDeploymentCommand = (lib.mkIf config.settings.comin.autoReboot rebootScript);
      remotes = builtins.map (remote: {
        url = remote.url;
        name = remote.name;
        branches.main.name = remote.branch;
        poller.period = remote.pollInterval;
      }) config.settings.comin.remotes;
    };
  };
}
