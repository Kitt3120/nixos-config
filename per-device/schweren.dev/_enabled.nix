{ config, pkgs, ... }:

{
  imports = [
    ./firewall/_enabled.nix
    ./users/_enabled.nix
    
    ./desktop.nix
    ./gpu.nix
    ./hostname.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./settings-defaults.nix
    ./system.nix
    ./virtualization.nix
  ];
}
