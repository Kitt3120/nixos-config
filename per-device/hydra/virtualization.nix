{ config, pkgs, ... }:

{
  imports = [
    ../../virtualization/per-device/docker.nix
    ../../virtualization/per-device/libvirt.nix
  ];
}
