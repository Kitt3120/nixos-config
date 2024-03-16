{ config, pkgs, ... }:

{
  gtk.iconCache.enable = true;
  
  environment.systemPackages = with pkgs; [
    gtk2
    gtk3
    gtk4
  ];
}