{ config, pkgs, ... }:

{
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  imports = [
    ./plasma-qt.nix
    ./plasma-base.nix
  ];
}