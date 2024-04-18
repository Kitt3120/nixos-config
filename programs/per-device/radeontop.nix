{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ radeontop ];
}