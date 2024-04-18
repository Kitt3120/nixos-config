{ config, pkgs, ... }:

{
  imports = [
    ./appimage-run.nix
    ./pciutils.nix
    ./usbutils.nix
    ./fdisk.nix
    ./gdisk.nix
    ./parted.nix
    ./killall.nix
    ./htop.nix
    ./btop.nix
    ./fish.nix
    ./thefuck.nix
    ./zoxide.nix
    ./mail.nix
    ./git.nix
    ./nix-prefetch-github.nix
    ./java.nix
    ./neofetch.nix
    ./uwufetch.nix
    ./ffmpeg.nix
    ./lm_sensors.nix
    ./dfc.nix
  ];
}