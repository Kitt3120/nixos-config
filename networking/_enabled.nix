{ config, pkgs, ... }:

{
  imports = [
    ./firewall.nix
    ./nftables.nix
    ./wireguard.nix
  ];
}
