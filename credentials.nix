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
    };
  };
}