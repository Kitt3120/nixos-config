{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wineWowPackages.stagingFull ];

  imports = [ ./wine-base.nix ];
}
