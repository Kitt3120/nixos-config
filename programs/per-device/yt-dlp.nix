{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ yt-dlp ];
}
