{ config, pkgs, ... }:

{
  imports = [
    ./mapUsers.nix
    ./mkMinecraftServer.nix
  ];
}