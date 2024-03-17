{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ tor-browser ];
}