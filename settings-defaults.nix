{ config, pkgs, lib, ... }:

{
  options = {
    credentials = {
      torben = {
        hashedPassword = lib.mkOption {
          default = "";
          type = lib.types.str;
        };
      };

      minecraft = {
        hashedPassword = lib.mkOption {
          default = "";
          type = lib.types.str;
        };
      };

      authorizedKeys = lib.mkOption {
        default = [
            ""
        ];
        type = lib.types.listOf lib.types.str;
      };

      mail = {
        host = lib.mkOption {
          default = "";
          type = lib.types.str;
        };

        from =  lib.mkOption {
          default = lib.strings.concatStrings [config.networking.hostName " <>"];
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
            default = "01:00";
            type = lib.types.str;
          };

          upper = lib.mkOption {
            default = "05:00";
            type = lib.types.str;
          };
        }
      }
    };

    ssh = {
      blocks = {
        mrmeeseeks = lib.mkOption {
          default = ''
            Host <>
              HostName <>
              User <>
            
            '';
          type = lib.types.str;
        };

        schweren-dev = lib.mkOption {
          default = ''
            Host schweren.dev
              HostName <>
              User <>
            
          '';
          type = lib.types.str;
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
    }
  };
}
