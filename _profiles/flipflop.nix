{ lib, ... }:

{
  imports = [
    ../_presets/global.nix

    ../_presets/desktop.nix
    ../_presets/development.nix
    ../_presets/gaming.nix
    ../_presets/media.nix
    ../_presets/pentesting.nix
    ../_presets/productivity.nix
    ../_presets/social.nix

    ./flipflop/hardware-configuration.nix
    ./flipflop/settings.nix

    ./flipflop/desktop.nix
    ./flipflop/hostname.nix
    ./flipflop/networking.nix
    ./flipflop/programs.nix
    ./flipflop/services.nix
    ./flipflop/system.nix
    ./flipflop/virtualization.nix
  ];

  # Only during initial installation
  services.comin.enable = lib.mkForce false; # TODO: Remove
}
