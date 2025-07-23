{
  config,
  pkgs,
  lib,
  ...
}:

let
  btop =
    if builtins.elem "amdgpu" config.boot.initrd.kernelModules then
      pkgs.btop-rocm
    else if config.hardware.nvidia.enabled then
      pkgs.btop-nvidia
    else
      pkgs.btop;
in
{
  environment.systemPackages = [ btop ];
}
