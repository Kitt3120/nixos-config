{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ kdePackages.kdenlive ];
}