{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.autoUpgrade = {
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
    enable = config.autoUpgrade.enable;
    dates = config.autoUpgrade.dates;
    persistent = config.autoUpgrade.persistent;
    allowReboot = config.autoUpgrade.autoReboot.enable;
    rebootWindow = {
      lower = config.autoUpgrade.autoReboot.window.lower;
      upper = config.autoUpgrade.autoReboot.window.upper;
    };
  };
}
