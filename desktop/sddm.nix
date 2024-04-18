{ config, pkgs, ... }:

{
  services.displayManager = {
    defaultSession =
      if config.services.xserver.desktopManager.plasma5.enable then
        "plasmawayland"
      else if config.services.desktopManager.plasma6.enable then
        "plasma"
      else
        "none";

    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      autoNumlock = true;
    };
  };
}