{ config, pkgs, ... }:

{
  imports = [
    ../../networking/firewall.nix
    ../../networking/wireguard.nix
  ];
}
