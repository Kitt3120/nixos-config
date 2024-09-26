{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  # See https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };
}
