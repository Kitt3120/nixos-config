{ config, pkgs, ... }:

{
  qt.enable = true;
  environment.systemPackages = with pkgs; [ libsForQt5.full ];
}
