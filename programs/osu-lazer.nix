{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ osu-lazer-bin ];

  home-manager.users =
    if config.programs.xwayland.enable then
      config.mapAllUsersToSet (user: {
        "${user}".home.file.".local/share/applications/osu!-Wayland.desktop".text = ''
          # Desktop Entry Specification: https://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html

          [Desktop Entry]
          Version=1.5
          Type=Application
          Name=osu! (Wayland)
          Comment=A free-to-win rhythm game. Rhythm is just a *click* away!
          Icon=osu
          Exec=env COMPlus_GCGen0MaxBudget=600000 SDL_VIDEODRIVER=wayland osu! %u
          Terminal=false
          MimeType=application/x-osu-beatmap-archive;application/x-osu-skin-archive;application/x-osu-beatmap;application/x-osu-storyboard;application/x-osu-replay;x-scheme-handler/osu;
          Categories=Game;
          StartupWMClass=osu!
          SingleMainWindow=true
          StartupNotify=true
        '';
      })
    else
      { };
}
