{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wineWowPackages.stable ];

  imports = [ ./wine-base.nix ];
}
