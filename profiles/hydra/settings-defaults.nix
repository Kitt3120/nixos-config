{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    credentials = {
      user = {
        torben = {
          hashedPassword = lib.mkOption {
            default = "";
            type = lib.types.str;
          };

          ssh = {
            authorizedKeys = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.str;
            };

            blocks = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.str;
            };
          };
        };
      };
    };

    smartd = {
      temperatureChangeThreshold = lib.mkOption {
        default = 4;
        type = lib.types.int;
      };

      temperatureLog = lib.mkOption {
        default = 70;
        type = lib.types.int;
      };

      temperatureMax = lib.mkOption {
        default = 70;
        type = lib.types.int;
      };
    };
  };
}
