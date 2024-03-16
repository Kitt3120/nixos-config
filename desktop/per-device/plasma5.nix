{ config, pkgs, ... }:

{
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    phononBackend = "vlc";
  };

  imports = [
    ./plasma-qt.nix
    ./plasma-base.nix
  ];
}