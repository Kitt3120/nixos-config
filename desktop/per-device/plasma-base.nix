# DO NOT IMPORT THIS MODULE MANUALLY
# This module gets imported by the plasma5 and plasma6 modules

{ config, pkgs, lib, ... }:

{
  programs.kdeconnect.enable = true;

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
    config.common.default = lib.mkDefault "kde";
  };
  
  environment.systemPackages = with pkgs; [ 
    kdePackages.sddm-kcm
    kdePackages.flatpak-kcm
    #kdePackages.plasma-disks # TODO: Enable again when plasma-disks has been fixed
    kdePackages.kde-gtk-config
    kdePackages.packagekit-qt
    kdePackages.plasma-nm
    kdePackages.plasma-systemmonitor
    kdePackages.plasma-integration
    kdePackages.kinfocenter
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.baloo
    kdePackages.bluedevil
    kdePackages.plasma-browser-integration
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kdesdk-thumbnailers
    kdePackages.kimageformats
    kdePackages.qtimageformats
    kdePackages.ffmpegthumbs
    kdePackages.taglib
    kdePackages.kio-extras
    kdePackages.yakuake
    kdePackages.spectacle
    kdePackages.skanpage
    kdePackages.okular
    kdePackages.kate
    kdePackages.konsole
    kdePackages.discover
    kdePackages.dolphin
    kdePackages.kolourpaint
    #kdePackages.kamoso # TODO: Enable again when package updated
    kdePackages.filelight
    kwalletcli
    libheif
    xwaylandvideobridge
    #plasma-wallpaper-engine # TODO: Find way to package software, as it is not available
  ];
}