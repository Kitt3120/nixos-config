{ config, pkgs, ... }:

{
  imports = [
    ../../programs/per-device/nvtop.nix
    ../../programs/per-device/wine-staging.nix
    ../../programs/per-device/yt-dlp.nix
  ];
}
