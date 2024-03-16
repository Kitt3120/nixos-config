{ config, pkgs, ... }:

{
  imports = [
    ./autoUpgrade.nix
    ./fwupd.nix
    ./bootloader.nix
    ./networking.nix
    ./time.nix
    ./locale.nix
    ./nixgc.nix
    ./flatpak.nix
  ];
}