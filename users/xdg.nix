{ config, ... }:
{
  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".xdg.enable = true;
  });
}
