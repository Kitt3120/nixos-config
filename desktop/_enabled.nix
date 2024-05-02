{ config, pkgs, ... }:

{
  imports = [
    ./xserver.nix
    ./wayland.nix

    ./libinput.nix

    ./sddm.nix

    ./qt.nix
    ./gtk.nix

    ./xdg-desktop-portal.nix
    ./pipewire.nix
    ./fonts.nix
    ./hunspell.nix
  ];
}
