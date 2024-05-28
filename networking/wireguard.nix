{ config, pkgs, ... }:

{
  networking.wireguard.interfaces = config.wireguard.interfaces;
}
