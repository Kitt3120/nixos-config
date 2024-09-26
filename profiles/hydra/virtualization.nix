{ config, pkgs, ... }:

{
  imports = [
    ../../virtualization/docker.nix
    ../../virtualization/libvirt.nix
  ];
}
