{ config, pkgs, ... }:

{
  imports = [
    ./users/minecraft/ssh.nix
    ./users/minecraft/user.nix
    #./users/minecraft/services/minecraft-mdj.nix
    #./users/minecraft/services/minecraft-scary.nix
    #./users/minecraft/services/minecraft-adventure.nix
    #./users/minecraft/services/minecraft-dud.nix
    #./users/minecraft/services/minecraft-redstone.nix
    #./users/minecraft/services/minecraft-horror.nix
  ];
}
