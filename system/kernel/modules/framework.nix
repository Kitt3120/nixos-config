{ config, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [ framework-laptop-kmod ];
}
