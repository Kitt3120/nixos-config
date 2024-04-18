{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ opentabletdriver ];
}