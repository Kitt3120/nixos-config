{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ libnotify ];
}
