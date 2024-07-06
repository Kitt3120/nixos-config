{ config, pkgs, ... }:

{
  imports = [
    ./mapUsers.nix
    ./mkMinecraftFabricServer.nix
    ./mkMinecraftForgeServer.nix
  ];
}