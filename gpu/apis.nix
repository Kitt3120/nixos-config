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
    clinfo
    wayland-utils
    glxinfo
    libdrm
    vulkan-tools
    vulkan-headers
    vulkan-extension-layer
    libva
    libva-utils
  ];
}