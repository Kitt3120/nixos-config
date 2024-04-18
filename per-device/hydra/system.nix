{ config, pkgs, ... }:

{
  imports = [
    ../../system/per-device/microcode-amd.nix
    ../../system/per-device/iio-sensor.nix 
  ];
}