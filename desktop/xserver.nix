{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    enableTCP = false;
    xkb = {
      layout = "de";
      variant = "deadgraveacute";
    };
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };
  };
}