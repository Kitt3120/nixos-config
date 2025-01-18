{ config, pkgs, ... }:

{
  qt = {
    platformTheme = "kde";
    style = "breeze";
  };

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-kde ];
    config.common.default = "kde";
  };

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  programs.kdeconnect.enable = true;
  networking.firewall.allowedTCPPorts = [ 3389 ]; # Allow new built-in RDP on Plasma 6.1+

  environment.systemPackages = with pkgs; [
    kdePackages.baloo
    kdePackages.bluedevil
    kdePackages.discover
    kdePackages.dolphin
    kdePackages.ffmpegthumbs
    kdePackages.filelight
    kdePackages.flatpak-kcm
    kdePackages.isoimagewriter
    kdePackages.kate
    kdePackages.kbackup
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kde-gtk-config
    kdePackages.kdebugsettings
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kdesdk-thumbnailers
    kdePackages.keysmith
    kdePackages.kfind
    kdePackages.kgpg
    kdePackages.kimageformats
    kdePackages.kinfocenter
    kdePackages.kio-extras
    kdePackages.kmousetool
    kdePackages.kolourpaint
    kdePackages.konsole
    kdePackages.krdc
    kdePackages.krfb
    kdePackages.ksystemlog
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kweather
    kdePackages.okular
    kdePackages.packagekit-qt
    kdePackages.partitionmanager
    kdePackages.plasma-browser-integration
    kdePackages.plasma-disks
    kdePackages.plasma-integration
    kdePackages.plasma-nm
    kdePackages.plasma-systemmonitor
    kdePackages.plasma-wayland-protocols
    kdePackages.plasma-workspace-wallpapers
    kdePackages.polkit-kde-agent-1
    kdePackages.qtimageformats
    kdePackages.sddm-kcm
    kdePackages.skanpage
    kdePackages.spectacle
    kdePackages.systemsettings
    kdePackages.taglib
    kdePackages.wayland
    kdePackages.yakuake
    libsForQt5.kamoso # Plasma 5 version (Plasma 6's kdePackages.kamoso) does not build
    kwalletcli
    libheif
    xwaylandvideobridge
    #plasma-wallpaper-engine # TODO: Find way to package software, as it is not available
  ];
}
