{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mesa
    driversi686Linux.mesa
    mesa-demos
    clinfo
    wayland-utils
    libdrm
    libva-vdpau-driver
    driversi686Linux.libva-vdpau-driver
    libvdpau-va-gl
    driversi686Linux.libvdpau-va-gl
    vdpauinfo
    driversi686Linux.vdpauinfo
    vulkan-tools
    vulkan-headers
    vulkan-extension-layer
    libva
    libva-utils
  ];
}