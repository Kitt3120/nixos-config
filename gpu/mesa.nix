{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa.opencl # Installs Rusticl, which can be opt-in using RUSTICL_ENABLE env var
    ];
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
