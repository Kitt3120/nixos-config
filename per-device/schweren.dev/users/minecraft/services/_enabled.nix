{ config, pkgs, ... }:

{
  imports = [
    #./minecraft-mdj.nix
    ./minecraft-scary.nix
  ];
}