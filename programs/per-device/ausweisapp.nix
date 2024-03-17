{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ausweisapp ];
}