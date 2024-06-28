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
              default = [];
              type = lib.types.listOf lib.types.str;
            };

            blocks = lib.mkOption {
              default = [];
              type = lib.types.listOf lib.types.str;
            };
          };
        };
      };
    };
  };
}
