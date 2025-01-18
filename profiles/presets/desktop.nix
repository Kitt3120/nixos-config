{ config, pkgs, ... }:

{
  imports = [
    ../../desktop/xserver.nix
    ../../desktop/wayland.nix

    ../../desktop/libinput.nix
    ../../desktop/inputmethods.nix

    ../../desktop/sddm.nix

    ../../desktop/qt.nix
    ../../desktop/gtk.nix

    ../../desktop/xdg-desktop-portal.nix
    ../../desktop/pipewire.nix
    ../../desktop/fonts.nix
    ../../desktop/hunspell.nix
  ];
}
