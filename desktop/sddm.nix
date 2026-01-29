{ config, ... }:

{
  services.displayManager = {
    defaultSession = if config.services.desktopManager.plasma6.enable then "plasma" else null;

    sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      autoNumlock = true;
    };
  };
}
