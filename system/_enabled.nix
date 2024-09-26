{ config, pkgs, ... }:

{
  imports = [
    ./autoUpgrade.nix
    ./firmware.nix
    ./locale.nix
    ./networking.nix
    ./nixgc.nix
    ./polkit.nix
    ./time.nix
    ./ulimit.nix
  ];
}
