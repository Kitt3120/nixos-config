{ config, pkgs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    timeoutStyle = "menu";
    efiSupport = true;
    device = "nodev";
  };
}