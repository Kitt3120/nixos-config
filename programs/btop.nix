{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ btop ];
}