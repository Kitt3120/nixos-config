{ config, pkgs, ... }:

{
  imports = [
    ../../desktop/_enabled.nix
    ../../desktop/per-device/plasma6.nix
  ];
}