{ config, pkgs, ... }:

{
  imports = [
    ../../services/per-device/ckb-next.nix
    ../../services/per-device/flatpak.nix
    ../../services/per-device/mullvad.nix
    ../../services/per-device/nixos-upgrade-notification/libnotify.nix
    ../../services/per-device/onedrive.nix
    ../../services/per-device/openrgb.nix
    ../../services/per-device/opentabletdriver.nix
    ../../services/per-device/smartd.nix
  ];
}