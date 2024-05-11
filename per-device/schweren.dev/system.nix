{ config, pkgs, ... }:

{
  imports = [
    ../../system/per-device/kernel/lts.nix
    ../../system/per-device/bootloader/grub.nix
    ../../system/per-device/bootloader/grub-cryptodisk.nix
    ../../system/per-device/bootloader/grub-memtest.nix
    ../../system/per-device/microcode/amd.nix
    ../../system/per-device/ryzen-smu.nix
  ];
}