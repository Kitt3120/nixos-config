{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.thefuck.enable = true;

  home-manager.users =
    if config.programs.fish.enable then
      config.mapAllUsersToSet (user: {
        "${user}".xdg.configFile."fish/conf.d/thefuck.fish".text = "thefuck --alias | source";
      })
    else
      { };
}
