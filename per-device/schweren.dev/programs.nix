{ config, pkgs, ... }:

{
  imports = [
    ../../programs/per-device/wine-staging.nix
    ../../programs/per-device/yt-dlp.nix
    ../../programs/per-device/nvtop.nix
  ];
}