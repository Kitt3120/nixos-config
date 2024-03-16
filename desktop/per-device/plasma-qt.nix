# DO NOT IMPORT THIS MODULE MANUALLY
# This module gets imported by the plasma5 and plasma6 modules

{ config, pkgs, ... }:

{
  qt = {
    platformTheme = "kde";
    style = "breeze";
  };
}