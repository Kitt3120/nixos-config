{ config, pkgs, lib, ... }:

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
          };
        };

        minecraft = {
          hashedPassword = lib.mkOption {
            default = "";
            type = lib.types.str;
          };

          ssh = {
            authorizedKeys = lib.mkOption {
              default = [ ];
              type = lib.types.listOf lib.types.str;
            };
          };
        };
      };
    };

    tor = {
      ContactInfo = lib.mkOption {
        default = "";
        type = lib.types.str;
      };

      Address = lib.mkOption {
        default = "";
        type = lib.types.str;
      };
      
      Nickname = lib.mkOption {
        default = "";
        type = lib.types.str;
      };

      role = lib.mkOption {
        default = "relay";
        type = lib.types.str;
      };

      ExitRelay = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };

      ExitPolicy = lib.mkOption {
        default = "reject *:*";
        type = lib.types.str;
      };

      BridgeRelay = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };

      openFirewall = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };

      ORPort = lib.mkOption {
        default = 9001;
        type = lib.types.int;
      };

      BandwidthRate = lib.mkOption {
        default = "1 MBytes";
        type = lib.types.str;
      };

      BandwidthBurst = lib.mkOption {
        default = "1 MBytes";
        type = lib.types.str;
      };
    };
  };
}
