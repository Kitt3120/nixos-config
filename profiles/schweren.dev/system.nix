{ config, pkgs, ... }:

{
  imports = [
    ../../system/bootloader/grub-cryptodisk.nix
    ../../system/bootloader/grub-memtest.nix
    ../../system/bootloader/grub.nix
    ../../system/kernel/lts.nix
    ../../system/microcode/amd.nix
    ../../system/ryzen-smu.nix
  ];
}
