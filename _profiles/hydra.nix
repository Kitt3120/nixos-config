{ config, pkgs, ... }:

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

    ./hydra/desktop.nix
    ./hydra/gpu.nix
    ./hydra/hostname.nix
    ./hydra/networking.nix
    ./hydra/programs.nix
    ./hydra/services.nix
    ./hydra/system.nix
    ./hydra/users.nix
    ./hydra/virtualization.nix
  ];
}
