{ config, pkgs, ... }:

{
  imports = [
    ../../programs/wine-staging.nix
    ../../programs/yt-dlp.nix
  ];
}
