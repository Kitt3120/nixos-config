{ config, pkgs, ... }:

{
  imports = [
    ../_presets/global.nix
    ../_presets/desktop.nix

    ./modulosaurus/desktop.nix
    ./modulosaurus/gpu.nix
    ./modulosaurus/hostname.nix
    ./modulosaurus/networking.nix
    ./modulosaurus/programs.nix
    ./modulosaurus/services.nix
    ./modulosaurus/system.nix
    ./modulosaurus/users.nix
    ./modulosaurus/virtualization.nix
  ];
}
