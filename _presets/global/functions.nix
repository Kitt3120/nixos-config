{ config, pkgs, ... }:

{
  imports = [
    ../../functions/mapUsers.nix
    ../../functions/mkMinecraftFabricServer.nix
    ../../functions/mkMinecraftServer.nix
  ];
}
