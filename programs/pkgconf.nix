{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgconf
    libpkgconf
  ];
}
