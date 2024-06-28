{ config, pkgs, ... }:

{
  imports = [
    ./autoUpgrade.nix
    ./locale.nix
    ./networking.nix
    ./nixgc.nix
    ./polkit.nix
    ./time.nix
    ./ulimit.nix
  ];
}