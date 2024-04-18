{ config, pkgs, ... }:

{
  imports = [
    ./users/_enabled.nix
    ./kernel.nix
    ./bootloader.nix
    ./system.nix
    ./hostname.nix
    ./gpu.nix
    ./services.nix
    ./desktop.nix
    ./programs.nix
  ];
}