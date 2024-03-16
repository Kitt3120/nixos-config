{ config, pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mesa
    mesa-demos
    libdrm
    glxinfo
    vulkan-tools
    vulkan-headers
    vulkan-extension-layer
    libva
    libva-utils
  ];
}