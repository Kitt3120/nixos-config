{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    credentials = {
      mail = {
        host = lib.mkOption {
          default = "";
          type = lib.types.str;
        };

        user = lib.mkOption {
          default = "";
          type = lib.types.str;
        };

        password = lib.mkOption {
          default = "";
          type = lib.types.str;
        };

        from = lib.mkOption {
          default = "";
          type = lib.types.str;
        };
      };
    };

    autoUpgrade = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };

      dates = lib.mkOption {
        default = "hourly";
        type = lib.types.str;
      };

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

    wireguard = {
      interfaces = lib.mkOption {
        default = { };
        type = lib.types.attrs;
      };
    };
  };
}
