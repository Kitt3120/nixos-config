{ config, pkgs, ... }:

{
  imports = [
    ../_presets/global.nix

    ./schweren.dev/firewall/mailcow.nix
    ./schweren.dev/firewall/playforia-minigolf.nix
    ./schweren.dev/firewall/satisfactory.nix
    ./schweren.dev/firewall/valheim.nix

    ./schweren.dev/hostname.nix
    ./schweren.dev/networking.nix
    ./schweren.dev/programs.nix
    ./schweren.dev/services.nix
    ./schweren.dev/settings-defaults.nix
    ./schweren.dev/system.nix
    ./schweren.dev/users.nix
    ./schweren.dev/virtualization.nix
  ];
}
