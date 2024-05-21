{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kitty
    kitty-themes
    kitty-img
  ];

  home-manager.users = config.mapAllUsersToSet (user: {
      "${user}".xdg.configFile."kitty/kitty.conf".text = ''
        shell_integration enabled
        confirm_os_window_close -1
      '';
    }
  );
}