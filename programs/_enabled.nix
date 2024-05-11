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
    ./llvm.nix
    ./pkgconf.nix
    ./pkg-config.nix
    ./openssl.nix
    ./gnumake.nix
    ./cpupower.nix
    ./fuse3.nix
    ./screen.nix
    ./speedtest-cli.nix
    ./python3.nix
    ./rsync.nix
  ];
}