{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ plex-media-player ];
}
