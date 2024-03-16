{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mangohud
    goverlay
  ];

  environment.variables.MANGOHUD = "1";
}