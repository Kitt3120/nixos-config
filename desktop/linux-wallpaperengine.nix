{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ linux-wallpaperengine ];
}
