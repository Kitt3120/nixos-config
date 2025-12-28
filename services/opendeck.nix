{ pkgs, ... }:

let
  pkgs-local = import /home/torben/Nextcloud/Programmierung/NixOS/nixpkgs {
    stdenv.hostPlatform.system = pkgs.stdenv.hostPlatform.system;
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
