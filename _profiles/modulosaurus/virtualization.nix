{ config, pkgs, ... }:

{
  imports = [
    ../../virtualization/docker.nix
    ../../virtualization/libvirt.nix
    ../../virtualization/waydroid.nix
  ];
}
