{ config, pkgs, ... }:

{
  environment.systemPackages = with config.boot.kernelPackages; [ cpupower ];
}