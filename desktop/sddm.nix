{ config, ... }:

{
  services.displayManager = {
    defaultSession =
      if config.services.desktopManager.plasma6.enable then
        "plasma"
      else if config.services.xserver.desktopManager.plasma5.enable then
        "plasmawayland"
      else
        null;

    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      autoNumlock = true;
    };
  };
}
