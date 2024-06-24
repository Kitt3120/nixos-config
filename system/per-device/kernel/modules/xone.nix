{ config, pkgs, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [ xone ];
}