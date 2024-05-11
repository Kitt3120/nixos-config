{ config, pkgs, ... }:

{
  imports = [
    ./autoUpgrade.nix
    ./networking.nix
    ./time.nix
    ./locale.nix
    ./nixgc.nix
    ./polkit.nix
  ];
}