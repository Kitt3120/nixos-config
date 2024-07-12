{ config, pkgs, ... }:

{
  imports = [
    ./firewall/_enabled.nix
    ./users/_enabled.nix
    
    ./hostname.nix
    ./networking.nix
    ./programs.nix
    ./services.nix
    ./settings-defaults.nix
    ./system.nix
    ./virtualization.nix
  ];
}
