{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";
  };

  users.defaultUserShell = pkgs.fish;
}
