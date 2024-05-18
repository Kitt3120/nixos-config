{ config, pkgs, ... }:

{
  imports = [
    ./firewall-mailcow.nix
    ./firewall-minecraft-mdj.nix
  ];
}
