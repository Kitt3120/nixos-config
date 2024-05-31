{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ libreoffice-qt-fresh ];
}