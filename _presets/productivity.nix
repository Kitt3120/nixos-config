{ config, pkgs, ... }:

{
  imports = [
    ../programs/anki.nix
    ../programs/ausweisapp.nix
    ../programs/bitwarden.nix
    ../programs/brave.nix
    ../programs/corectrl.nix
    ../programs/cpupower-gui.nix
    ../programs/gparted.nix
    ../programs/gsmartcontrol.nix
    ../programs/libreoffice.nix
    ../programs/nextcloud.nix
    ../programs/onedrive-gui.nix
    ../programs/onlyoffice.nix
    ../programs/pdfarranger.nix
    ../programs/qpdf.nix
    ../programs/remmina.nix
    ../programs/rustdesk.nix
    ../programs/texlive.nix
    ../programs/thunderbird.nix
    #../programs/ventoy.nix # TODO: Enable again when upstream removed blobs
  ];
}
