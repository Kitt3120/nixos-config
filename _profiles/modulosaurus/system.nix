{ config, pkgs, ... }:

{
  imports = [
    ../../system/bootloader/grub.nix
    ../../system/kernel/modules/xone.nix
    ../../system/kernel/zen.nix
  ];
}
