{ config, pkgs, ... }:

{
  imports = [
    ../../virtualization/libvirt.nix
    ../../virtualization/podman.nix
    ../../virtualization/waydroid.nix
  ];
}
