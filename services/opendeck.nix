{ pkgs, ... }:

let
  pkgs-local = import /home/torben/Nextcloud/Programmierung/NixOS/nixpkgs {
    system = pkgs.system;
    config = pkgs.config;
  };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      opendeck = pkgs-local.opendeck;
    })
  ];

  environment.systemPackages = with pkgs; [ opendeck ];
  services.udev.packages = with pkgs; [ opendeck ];
}
