{ config, pkgs, ... }:

let
  aagl = import (
    builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz"
  );
in
{
  imports = [
    aagl.module
  ];

  programs.anime-games-launcher.enable = true;

  programs.anime-game-launcher.enable = false;
  programs.honkers-railway-launcher.enable = false;
  programs.honkers-launcher.enable = false;
  programs.wavey-launcher.enable = false;
  programs.sleepy-launcher.enable = false;
}
