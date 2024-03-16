{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ zoxide ];

  home-manager.users = if config.programs.fish.enable then
    config.mapAllUsersToSet (user: {
      "${user}".xdg.configFile."fish/conf.d/zoxide.fish".text = "zoxide init --cmd cd fish | source";
    })
  else { };
}