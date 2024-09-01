{ config, pkgs, ... }:

{
  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
}