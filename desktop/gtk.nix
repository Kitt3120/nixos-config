{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gtk2
    gtk3
    gtk4
  ];
}
