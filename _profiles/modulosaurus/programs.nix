{ config, pkgs, ... }:

{
  imports = [
    ../../programs/adb.nix
    ../../programs/aircrack-ng.nix
    ../../programs/an-anime-team-launchers.nix
    ../../programs/ani-cli.nix
    ../../programs/anki.nix
    ../../programs/armitage.nix
    ../../programs/audacity.nix
    ../../programs/ausweisapp.nix
    ../../programs/bambu-studio.nix
    ../../programs/bitwarden.nix
    ../../programs/blender.nix
    ../../programs/burpsuite.nix
    ../../programs/corectrl.nix
    ../../programs/dolphin-emulator.nix
    ../../programs/easyeffects.nix
    ../../programs/exploitdb.nix
    ../../programs/firefox-nightly.nix
    ../../programs/gamemode.nix
    ../../programs/gamescope.nix
    ../../programs/gparted.nix
    ../../programs/gradle.nix
    ../../programs/gsmartcontrol.nix
    ../../programs/handbrake.nix
    ../../programs/hashcat.nix
    ../../programs/imagemagick.nix
    ../../programs/inkscape.nix
    ../../programs/jellyfin.nix
    ../../programs/jetbrains-toolbox.nix
    #../../programs/john.nix # TODO: Enable again when fixed
    ../../programs/kdenlive.nix
    ../../programs/kitty.nix
    ../../programs/krita.nix
    ../../programs/libnotify.nix
    ../../programs/libreoffice.nix
    ../../programs/librewolf.nix
    ../../programs/linux-wifi-hotspot.nix
    ../../programs/lutris.nix
    ../../programs/lshw-gui.nix
    ../../programs/mangohud.nix
    ../../programs/maven.nix
    #../../programs/mdk4.nix # TODO: Enable again when fixed
    ../../programs/metasploit.nix
    ../../programs/mkvtoolnix.nix
    ../../programs/mpv.nix
    ../../programs/nextcloud.nix
    ../../programs/nhentai.nix
    ../../programs/nvtop.nix
    ../../programs/obs-studio.nix
    ../../programs/onedrive-gui.nix
    ../../programs/onlyoffice.nix
    ../../programs/osu-lazer.nix
    ../../programs/plex-media-player.nix
    ../../programs/prism-launcher.nix
    ../../programs/protonup.nix
    ../../programs/qflipper.nix
    ../../programs/qrtool.nix
    ../../programs/remmina.nix
    ../../programs/retroarch.nix
    ../../programs/rustdesk.nix
    ../../programs/ryzen-monitor-ng.nix
    ../../programs/signal.nix
    ../../programs/sqlmap.nix
    ../../programs/steam.nix
    ../../programs/syncplay.nix
    ../../programs/teams-for-linux.nix
    ../../programs/thunderbird.nix
    ../../programs/tor-browser.nix
    ../../programs/ungoogled-chromium.nix
    ../../programs/uni-sync.nix
    ../../programs/ventoy.nix
    ../../programs/vesktop.nix
    #../../programs/vintage-story.nix # TODO: Enable again when fixed
    ../../programs/vlc.nix
    ../../programs/vscode.nix
    ../../programs/wallpaper-engine-kde-plugin.nix
    #../../programs/wifite2.nix # TODO: Enable again when fixed
    ../../programs/wootility.nix
    ../../programs/youtube-music.nix
    ../../programs/zap.nix
  ];
}
