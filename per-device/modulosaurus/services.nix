{ config, pkgs, ... }:

{
  imports = [ ../../services/per-device/bluetooth.nix ];
}