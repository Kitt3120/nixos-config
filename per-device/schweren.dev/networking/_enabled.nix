{ config, pkgs, ... }:

{
  imports = [
    ./firewall-mailcow.nix
  ];
}
