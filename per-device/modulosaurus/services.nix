{ config, pkgs, ... }:

{
  imports = [
    ../../services/per-device/nixos-upgrade-notification/notify.nix
    ../../services/per-device/bluetooth.nix
    ../../services/per-device/mullvad.nix
    ../../services/per-device/openrgb.nix
    ../../services/per-device/ckb-next.nix
    ../../services/per-device/docker.nix
    ../../services/per-device/opentabletdriver.nix
  ];
}