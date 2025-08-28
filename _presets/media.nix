{ config, pkgs, ... }:

{
  imports = [
    ../programs/ani-cli.nix
    #../programs/audacity.nix # TODO: Enable again when fixed
    ../programs/blender.nix
    ../programs/davinci-resolve-studio.nix
    ../programs/easyeffects.nix
    ../programs/handbrake.nix
    ../programs/imagemagick.nix
    ../programs/inkscape.nix
    #../programs/jellyfin.nix TODO: Enable again when fixed
    ../programs/kdenlive.nix
    ../programs/krita.nix
    ../programs/mkvtoolnix.nix
    ../programs/mpv.nix
    #../programs/nhentai.nix # TODO: Enable again when fixed
    ../programs/obs-studio.nix
    ../programs/plex-desktop.nix
    ../programs/vlc.nix
    ../programs/youtube-music.nix
  ];
}
