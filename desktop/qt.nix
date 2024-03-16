{ config, pkgs, ... }:

{
  qt.enable = true;
  # platformTheme and style set by desktop environment module

  environment.systemPackages = with pkgs; [
    libsForQt5.full
  ];
}