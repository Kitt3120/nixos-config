{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    enableTCP = false;
    xkb = {
      layout = "de";
      variant = "deadgraveacute";
    };
  };
}
