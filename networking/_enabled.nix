{ config, pkgs, ... }:

{
  imports = [
    ./firewall.nix
    ./wireguard.nix
  ];
}
