{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qFlipper ];
}