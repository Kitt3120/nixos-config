{ config, pkgs, ... }:

{
  imports = [
    ../../services/bluetooth.nix
    ../../services/flatpak.nix
    ../../services/fprintd.nix
    ../../services/media-pipelines-ffmpeg.nix
    ../../services/mullvad.nix
    ../../services/nixos-upgrade-notification/libnotify.nix
    ../../services/onedrive.nix
    ../../services/openrgb.nix
    ../../services/opentabletdriver.nix
    ../../services/powermanagement.nix
    ../../services/powertop.nix
    ../../services/thermald.nix
    ../../services/smartd.nix
  ];
}
