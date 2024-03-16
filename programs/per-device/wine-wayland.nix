{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wineWowPackages.waylandFull ];

  imports = [ ./wine-base.nix ];
}