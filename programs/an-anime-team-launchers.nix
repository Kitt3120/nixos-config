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

  #programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
  #programs.wavey-launcher.enable = true;
  #programs.sleepy-launcher.enable = true;
}
