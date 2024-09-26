{ config, pkgs, ... }:

{
  imports = [
    ../../programs/nvtop.nix
    ../../programs/wine-staging.nix
    ../../programs/yt-dlp.nix
  ];
}
