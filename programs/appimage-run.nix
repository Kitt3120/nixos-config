{ config, pkgs, ... }:

{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
