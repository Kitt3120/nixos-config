{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    enableTCP = false;
    videoDrivers = [ "modesetting" ];
    xkb = {
      layout = "de";
      variant = "deadgraveacute";
    };
  };
}
