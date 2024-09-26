{ config, pkgs, ... }:

{
  imports = [
    ../../system/bootloader/grub.nix
    ../../system/kernel/lts.nix
    ../../system/microcode/amd.nix
    ../../system/ryzen-smu.nix
  ];
}
