{ config, pkgs, ... }:

{
  imports = [
    ./presets/global.nix
    ./presets/desktop.nix

    ./modulosaurus/users/torben/git.nix
    ./modulosaurus/users/torben/ssh.nix
    ./modulosaurus/users/torben/user.nix

    ./modulosaurus/desktop.nix
    ./modulosaurus/gpu.nix
    ./modulosaurus/hostname.nix
    ./modulosaurus/programs.nix
    ./modulosaurus/services.nix
    ./modulosaurus/settings-defaults.nix
    ./modulosaurus/system.nix
    ./modulosaurus/virtualization.nix
  ];
}
