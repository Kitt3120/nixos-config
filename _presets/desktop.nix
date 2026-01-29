{ ... }:

{
  imports = [
    ../desktop/wayland.nix

    ../desktop/libinput.nix
    ../desktop/inputmethods.nix

    ../desktop/sddm.nix

    ../desktop/qt.nix
    ../desktop/gtk.nix

    ../desktop/appstream.nix
    ../desktop/xdg.nix
    ../desktop/pipewire.nix
    ../desktop/fonts.nix
    ../desktop/hunspell.nix
  ];
}
