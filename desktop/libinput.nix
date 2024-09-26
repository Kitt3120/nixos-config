{ config, pkgs, ... }:

{
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
}
