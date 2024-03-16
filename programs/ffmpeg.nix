{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ffmpeg-full ];  
}