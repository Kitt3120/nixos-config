{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

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

  config =
    let
      comin = config.services.comin.package;
      ripgrep = pkgs.ripgrep;
      rebootScript =
        with pkgs;
        (writeShellScriptBin "comin-reboot-if-needed" ''
          ${comin}/bin/comin status | ${ripgrep}/bin/rg -q 'Need to reboot: yes' && reboot
        '');
    in
    {
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
