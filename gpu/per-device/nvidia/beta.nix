{ config, pkgs, ... }:

{
  imports = [ ./base.nix ];

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
}
