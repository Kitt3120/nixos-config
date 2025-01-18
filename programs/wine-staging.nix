{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
    protontricks
    protonup-qt
  ];
}
