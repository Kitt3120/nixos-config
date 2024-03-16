{ config, pkgs, lib, ... }:

{
  networking = {
    networkmanager.enable = true;
    hostName = lib.mkDefault "nixos";
  };
}