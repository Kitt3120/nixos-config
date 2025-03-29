{ config, pkgs, ... }:

{
  imports = [
    ./minecraft/ssh.nix
    ./minecraft/user.nix
    #./minecraft/services/minecraft-mdj.nix
    #./minecraft/services/minecraft-scary.nix
    #./minecraft/services/minecraft-adventure.nix
    #./minecraft/services/minecraft-dud.nix
    #./minecraft/services/minecraft-redstone.nix
    #./minecraft/services/minecraft-horror.nix
  ];
}
