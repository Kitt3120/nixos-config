{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ podman-desktop ];
}
