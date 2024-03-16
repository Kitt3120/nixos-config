{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ osu-lazer-bin ];

  home-manager.users = if config.programs.xwayland.enable then
    config.mapAllUsersToSet (user: {
      "${user}".home.file.".local/share/applications/osu!-Wayland.desktop".text = ''
        # Desktop Entry Specification: https://standards.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html

        [Desktop Entry]
        Type=Application
        Name=osu! (Wayland)
        Comment=A free-to-win rhythm game. Rhythm is just a *click* away!
        Icon=osu!
        Exec=env COMPlus_GCGen0MaxBudget=600000 SDL_VIDEODRIVER=wayland osu!
        Terminal=false
        Categories=Game;
        StartupWMClass=osu!
        SingleMainWindow=true
      '';
    })
  else { };
}