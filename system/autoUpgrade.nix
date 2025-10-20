{
  config,
  lib,
  self,
  ...
}:

{
  options.settings.autoUpgrade = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };

    dates = lib.mkOption {
      default = "hourly";
      type = lib.types.str;
    };

    autoReboot = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };

      window = {
        lower = lib.mkOption {
          default = "03:00";
          type = lib.types.str;
        };

        upper = lib.mkOption {
          default = "06:00";
          type = lib.types.str;
        };
      };
    };
  };

  config.system.autoUpgrade = {
    enable = config.settings.autoUpgrade.enable;
    dates = config.settings.autoUpgrade.dates;
    persistent = false;
    allowReboot = config.settings.autoUpgrade.autoReboot.enable;
    rebootWindow = {
      lower = config.settings.autoUpgrade.autoReboot.window.lower;
      upper = config.settings.autoUpgrade.autoReboot.window.upper;
    };
    flake = self.outPath;
    flags = [
      "--update-input" # deprecated but still works for now
      "nixpkgs"
      "--update-input"
      "home-manager"
      "--update-input"
      "aagl"
      "--update-input"
      "nix-alien"
      "--update-input"
      "sops-nix"
      "--update-input"
      "vscode-server"
      "--no-write-lock-file"
      "-L" # prints build logs
    ];
  };
}
