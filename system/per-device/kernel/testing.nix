{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_testing;
}