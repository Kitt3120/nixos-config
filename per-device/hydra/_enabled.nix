{ config, pkgs, ... }:

{
  imports = [
    ./users/_enabled.nix

    ./desktop.nix
    ./gpu.nix
    ./hostname.nix
    ./programs.nix
    ./services.nix
    ./system.nix
  ];
}