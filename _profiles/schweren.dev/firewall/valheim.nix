{ config, pkgs, ... }:

{
  networking.firewall.allowedUDPPorts = [
    2456
    2457
    2458
  ];
}
