{ config, pkgs, ... }:

{
  imports = [
    ./users/_enabled.nix
    ./system.nix
    ./hostname.nix
    ./gpu.nix
    ./services.nix
    ./desktop.nix
    ./programs.nix
  ];
}