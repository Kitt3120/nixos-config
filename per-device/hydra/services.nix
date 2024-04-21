{ config, pkgs, ... }:

{
  imports = [
    ../../services/per-device/bluetooth.nix
    ../../services/per-device/mullvad.nix
    ../../services/per-device/openrgb.nix
    ../../services/per-device/docker.nix
    ../../services/per-device/fprintd.nix
    ../../services/per-device/powermanagement.nix
    ../../services/per-device/thermald.nix
    #../../services/per-device/tlp.nix
    ../../services/per-device/opentabletdriver.nix
  ];
}