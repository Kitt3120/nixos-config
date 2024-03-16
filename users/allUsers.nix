{ config, lib, pkgs, ... }:

{
  options = {
    allUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of all defined users";
    };
  };
}