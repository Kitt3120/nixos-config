{ config, pkgs, ... }:

{
  imports = [
    ./firewall.nix
    ./nftables.nix
  ];
}
