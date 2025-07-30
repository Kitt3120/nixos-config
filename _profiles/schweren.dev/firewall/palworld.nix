{ config, pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [
    8211
  ];
}
