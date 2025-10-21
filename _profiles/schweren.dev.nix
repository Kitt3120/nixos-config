{ ... }:

{
  imports = [
    ../_presets/global.nix

    ../_presets/amd-cpu.nix

    ./schweren.dev/firewall/mailcow.nix
    ./schweren.dev/firewall/palworld.nix
    ./schweren.dev/firewall/playforia-minigolf.nix
    ./schweren.dev/firewall/satisfactory.nix
    ./schweren.dev/firewall/valheim.nix

    ./schweren.dev/hardware-configuration.nix
    ./schweren.dev/settings.nix

    ./schweren.dev/hostname.nix
    ./schweren.dev/networking.nix
    ./schweren.dev/services.nix
    ./schweren.dev/system.nix
    ./schweren.dev/users.nix
    ./schweren.dev/virtualization.nix
  ];
}
