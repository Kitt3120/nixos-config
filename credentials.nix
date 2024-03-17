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
  };
}