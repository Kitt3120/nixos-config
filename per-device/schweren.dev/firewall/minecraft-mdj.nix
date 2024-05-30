{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 25565 ];
}
