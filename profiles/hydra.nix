{ config, pkgs, ... }:

{
  imports = [
    ./presets/global.nix
    ./presets/desktop.nix

    ./hydra/desktop.nix
    ./hydra/gpu.nix
    ./hydra/hostname.nix
    ./hydra/programs.nix
    ./hydra/services.nix
    ./hydra/settings-defaults.nix
    ./hydra/system.nix
    ./hydra/virtualization.nix
  ];
}
