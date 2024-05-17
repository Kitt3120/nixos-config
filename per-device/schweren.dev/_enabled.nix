{ config, pkgs, ... }:

{
  imports = [
    ./networking/_enabled.nix
    ./users/_enabled.nix
    
    ./desktop.nix
    ./gpu.nix
    ./hostname.nix
    ./programs.nix
    ./services.nix
    ./settings-defaults.nix
    ./system.nix
  ];
}
