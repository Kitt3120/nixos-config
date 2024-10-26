{ config, pkgs, ... }:

{
  imports = [
    ../../desktop/plasma/plasma.nix
    ../../desktop/plasma/plasma-disks.nix
  ];
}
