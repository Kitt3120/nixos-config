{ config, pkgs, ... }:

{
  imports = [
    ./presets/global.nix

    ./schweren.dev/firewall/mailcow.nix
    ./schweren.dev/firewall/satisfactory.nix

    ./schweren.dev/users/minecraft/ssh.nix
    ./schweren.dev/users/minecraft/user.nix
    #./schweren.dev/users/minecraft/services/minecraft-mdj.nix
    #./schweren.dev/users/minecraft/services/minecraft-scary.nix
    ./schweren.dev/users/minecraft/services/minecraft-adventure.nix
    #./schweren.dev/users/minecraft/services/minecraft-dud.nix

    ./schweren.dev/users/torben/git.nix
    ./schweren.dev/users/torben/ssh.nix
    ./schweren.dev/users/torben/user.nix

    ./schweren.dev/hostname.nix
    ./schweren.dev/networking.nix
    ./schweren.dev/programs.nix
    ./schweren.dev/services.nix
    ./schweren.dev/settings-defaults.nix
    ./schweren.dev/system.nix
    ./schweren.dev/virtualization.nix
  ];
}
