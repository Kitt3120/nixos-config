{
  config,
  lib,
  pkgs,
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

    # Doesn't really work when using a VPN, it will always fail
    persistent = lib.mkOption {
      default = false;
      type = lib.types.bool;
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
    persistent = config.settings.autoUpgrade.persistent;
    allowReboot = config.settings.autoUpgrade.autoReboot.enable;
    rebootWindow = {
      lower = config.settings.autoUpgrade.autoReboot.window.lower;
      upper = config.settings.autoUpgrade.autoReboot.window.upper;
    };
  };
}
