{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    winetricks
    protontricks
    protonup-qt
  ];
}