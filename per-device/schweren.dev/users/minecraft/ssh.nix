{ config, pkgs, lib, ... }:

{
  users.users.minecraft.openssh.authorizedKeys.keys = config.credentials.authorizedKeys;
}