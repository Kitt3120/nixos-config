{ config, pkgs, ... }:

{
  imports = [
    ./autoUpgrade.nix
    ./fwupd.nix
    ./networking.nix
    ./time.nix
    ./locale.nix
    ./nixgc.nix
    ./dbus.nix
    ./flatpak.nix
    ./polkit.nix
  ];
}