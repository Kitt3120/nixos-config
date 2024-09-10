{ config, pkgs, ... }:

{
  imports = [
    #./minecraft-mdj.nix
    #./minecraft-scary.nix
    ./minecraft-adventure.nix
    #./minecraft-dud.nix
  ];
}
