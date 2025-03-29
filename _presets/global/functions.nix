{ config, pkgs, ... }:

{
  imports = [
    ../../functions/mapUsers.nix
    ../../functions/mkMinecraftServer.nix
    ../../functions/mkMinecraftForgeServer.nix
  ];
}
