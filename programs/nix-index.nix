{ config, pkgs, ... }:

{
  programs.nix-index = {
    enable = true;

    # They are conflicting with command-not-found
    enableBashIntegration = false;
    enableZshIntegration = false;
  };

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}" = {
      systemd.user.services.nix-index = {
        Unit.Description = "Build the nix-index database";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.nix-index}/bin/nix-index";
        };
      };

      systemd.user.timers.nix-index = {
        Unit.Description = "Build the nix-index database daily";
        Timer = {
          OnCalendar = "daily";
          Persistent = true;
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  });
}
