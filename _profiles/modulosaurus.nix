{ ... }:

{
  imports = [
    ../_presets/global.nix

    ../_presets/amd-cpu.nix
    ../_presets/amd-gpu.nix
    ../_presets/gpu.nix

    ../_presets/desktop.nix
    ../_presets/development.nix
    ../_presets/gaming.nix
    ../_presets/media.nix
    ../_presets/pentesting.nix
    ../_presets/productivity.nix
    ../_presets/social.nix

    ./modulosaurus/hardware-configuration.nix
    ./modulosaurus/settings.nix

    ./modulosaurus/desktop.nix
    ./modulosaurus/hostname.nix
    ./modulosaurus/networking.nix
    ./modulosaurus/programs.nix
    ./modulosaurus/services.nix
    ./modulosaurus/system.nix
    ./modulosaurus/virtualization.nix
  ];
}
