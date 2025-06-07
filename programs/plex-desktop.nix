{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ plex-desktop ];
}
