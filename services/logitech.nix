{ pkgs, ... }:

{
  hardware.logitech.wireless = {
    enable = true;
  };

  programs.solaar.enable = true;
}
