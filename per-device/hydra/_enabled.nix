{ config, pkgs, ... }:

{
  imports = [
    ./users/_enabled.nix

    ./desktop.nix
    ./gpu.nix
    ./hostname.nix
    ./programs.nix
    ./services.nix
    ./settings-defaults.nix
    ./system.nix
    ./virtualization.nix
  ];
}
