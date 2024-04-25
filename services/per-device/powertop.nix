{ config, pkgs, ... }:

{
  powerManagement.powertop.enable = true;

  environment.systemPackages = [
    pkgs.powertop
  ];
}