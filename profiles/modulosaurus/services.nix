{ config, pkgs, ... }:

{
  imports = [
    ../../services/ckb-next.nix
    ../../services/flatpak.nix
    ../../services/media-pipelines.nix
    ../../services/mullvad.nix
    ../../services/nixos-upgrade-notification/libnotify.nix
    ../../services/onedrive.nix
    ../../services/openrgb.nix
    ../../services/opentabletdriver.nix
  ];
}