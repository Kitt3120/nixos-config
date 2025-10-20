{ config, ... }:

{
  environment.systemPackages = with config.boot.kernelPackages; [ cpupower ];
}
