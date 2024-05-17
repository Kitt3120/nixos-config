{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [
    25
    465
    587
    143
    993
    110
    995
    4190
  ];
}
