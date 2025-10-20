{ config, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [ xone ];
}
