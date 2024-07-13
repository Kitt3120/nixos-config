{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pkgs.openrgb-with-all-plugins ];
  services.udev.packages = [ pkgs.openrgb-with-all-plugins ];
}