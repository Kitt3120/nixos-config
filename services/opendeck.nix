{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      opendeck =
        final.callPackage
          /home/torben/Nextcloud/Programmierung/NixOS/nixpkgs/pkgs/by-name/op/opendeck/package.nix
          { };
    })
  ];

  environment.systemPackages = [
    pkgs.opendeck
    pkgs.streamdeck-ui
  ];
  services.udev.packages = [
    pkgs.opendeck
    pkgs.streamdeck-ui
  ];
}
