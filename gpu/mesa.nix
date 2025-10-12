{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    mesa-demos
    vulkan-tools
    vulkan-headers
    clinfo
    libdrm
    libvdpau
    vdpauinfo
    driversi686Linux.vdpauinfo
    libva
    libva-utils
    wayland-utils
  ];
}
