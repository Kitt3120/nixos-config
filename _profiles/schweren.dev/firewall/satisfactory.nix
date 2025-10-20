{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 7777 ];
    allowedUDPPorts = [ 7777 ];
  };
}
