{ config, pkgs, ... }:

{
  system.autoUpgrade = {
    enable = config.autoUpgrade.enable;
    dates = config.autoUpgrade.dates;
    persistent = config.autoUpgrade.persistent;
    allowReboot = config.autoUpgrade.autoReboot.enable;
    rebootWindow = {
      lower = config.autoUpgrade.autoReboot.window.lower;
      upper = config.autoUpgrade.autoReboot.window.upper;
    };
  };
}