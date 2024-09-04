{ config, pkgs, ... }:

{
  imports = [
    ../../programs/per-device/adb.nix
    ../../programs/per-device/aircrack-ng.nix
    ../../programs/per-device/ani-cli.nix
    ../../programs/per-device/audacity.nix
    ../../programs/per-device/ausweisapp.nix
    ../../programs/per-device/bambu-studio.nix
    ../../programs/per-device/bitwarden.nix
    ../../programs/per-device/blender.nix
    ../../programs/per-device/burpsuite.nix
    ../../programs/per-device/discord.nix
    ../../programs/per-device/dolphin-emulator.nix
    ../../programs/per-device/easyeffects.nix
    ../../programs/per-device/firefox-nightly.nix
    ../../programs/per-device/framework-tool.nix
    ../../programs/per-device/gamemode.nix
    ../../programs/per-device/gamescope.nix
    ../../programs/per-device/gparted.nix
    ../../programs/per-device/gradle.nix
    ../../programs/per-device/handbrake.nix
    ../../programs/per-device/hashcat.nix
    ../../programs/per-device/imagemagick.nix
    ../../programs/per-device/inkscape.nix
    ../../programs/per-device/jetbrains-toolbox.nix
    ../../programs/per-device/john.nix
    ../../programs/per-device/joplin.nix
    ../../programs/per-device/kdenlive.nix
    ../../programs/per-device/kitty.nix
    ../../programs/per-device/krita.nix
    ../../programs/per-device/libreoffice.nix
    ../../programs/per-device/libnotify.nix
    ../../programs/per-device/linux-wifi-hotspot.nix
    ../../programs/per-device/lutris.nix
    ../../programs/per-device/lshw-gui.nix
    ../../programs/per-device/mangohud.nix
    ../../programs/per-device/maven.nix
    ../../programs/per-device/mdk4.nix
    ../../programs/per-device/mkvtoolnix.nix
    ../../programs/per-device/nextcloud.nix
    ../../programs/per-device/nhentai.nix
    ../../programs/per-device/nvtop.nix
    ../../programs/per-device/obs-studio.nix
    ../../programs/per-device/onedrive-gui.nix
    ../../programs/per-device/onlyoffice.nix
    ../../programs/per-device/osu-lazer.nix
    ../../programs/per-device/plex-media-player.nix
    ../../programs/per-device/prism-launcher.nix
    ../../programs/per-device/qflipper.nix
    ../../programs/per-device/qrtool.nix
    ../../programs/per-device/remmina.nix
    ../../programs/per-device/retroarch.nix
    ../../programs/per-device/ryzen-monitor-ng.nix
    ../../programs/per-device/signal.nix
    ../../programs/per-device/steam.nix
    ../../programs/per-device/syncplay.nix
    ../../programs/per-device/teams-for-linux.nix
    ../../programs/per-device/thunderbird.nix
    ../../programs/per-device/tor-browser.nix
    ../../programs/per-device/ungoogled-chromium.nix
    ../../programs/per-device/ventoy.nix
    ../../programs/per-device/vintage-story.nix
    ../../programs/per-device/vlc.nix
    ../../programs/per-device/vscode.nix
    ../../programs/per-device/webcord.nix
    ../../programs/per-device/wifite2.nix
    ../../programs/per-device/wine-staging.nix
    ../../programs/per-device/wootility.nix
    ../../programs/per-device/youtube-music.nix
    ../../programs/per-device/yt-dlp.nix
    ../../programs/per-device/zap.nix
  ];
}