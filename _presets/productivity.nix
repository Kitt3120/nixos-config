{ ... }:

{
  imports = [
    ../programs/anki.nix
    ../programs/ausweisapp.nix
    ../programs/bitwarden.nix
    #../programs/brave.nix # TODO: enable again when upstream got their shit together
    ../programs/gparted.nix
    ../programs/gsmartcontrol.nix
    ../programs/nextcloud.nix
    #../programs/onlyoffice.nix # TODO: enable when fixed upstream
    ../programs/pdfarranger.nix
    ../programs/qpdf.nix
    ../programs/remmina.nix
    #../programs/rustdesk.nix # TOOD: enable when fixed upstream
    ../programs/tesseract.nix
    ../programs/texlive.nix
    ../programs/thunderbird.nix
    ../programs/winboat.nix
    ../programs/xournalpp.nix
  ];
}
