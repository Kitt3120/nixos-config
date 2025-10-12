{ config, pkgs, ... }:

{
  imports = [
    ../../services/ckb-next.nix
    ../../services/flatpak.nix
    ../../services/media-pipelines-ffmpeg.nix
    ../../services/mullvad.nix
    ../../services/nixos-upgrade-notification/libnotify.nix
    ../../services/openrgb.nix
    ../../services/opentabletdriver.nix
    ../../services/smartd.nix
    ../../services/sunshine.nix
  ];
}
