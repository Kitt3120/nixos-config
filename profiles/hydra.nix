{ config, pkgs, ... }:

{
  imports = [
    ./presets/global.nix
    ./presets/desktop.nix

    ./hydra/users/torben/git.nix
    ./hydra/users/torben/ssh.nix
    ./hydra/users/torben/user.nix

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
