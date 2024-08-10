{ config, pkgs, ... }:

{
  imports = [
    ../../desktop/_enabled.nix

    ../../desktop/per-device/plasma.nix
    #../../desktop/per-device/stylix.nix
  ];
}