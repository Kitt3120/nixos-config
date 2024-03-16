{ config, pkgs, ... }:

{
  networking = {
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "192.168.178.50";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.178.1";
    nameservers = [ "192.168.178.10" "192.168.178.1" ];
  };
}
