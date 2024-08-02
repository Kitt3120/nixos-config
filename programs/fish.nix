{ config, pkgs, lib, ... }:

{
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".xdg.configFile = {
      "fish/conf.d/disable_greeting.fish".text = "set fish_greeting";
      "fish/conf.d/cargo.fish".text = "fish_add_path $HOME/.cargo/bin";
    };
  });
}