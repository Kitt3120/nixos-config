{ config, pkgs, ... }:

let
  isAmdGpu =
    config.hardware.amdgpu.initrd.enable
    || config.hardware.amdgpu.opencl.enable
    || config.hardware.amdgpu.overdrive.enable;
in
{
  services.xserver = {
    enable = true;
    enableTCP = false;
    videoDrivers = if isAmdGpu then [ "amdgpu" ] else [ ];
    xkb = {
      layout = "de";
      variant = "deadgraveacute";
    };
  };
}
