{ config, pkgs, ... }:

{
  imports = [
    ../../system/bootloader/grub.nix
    ../../system/kernel/modules/xone.nix
    ../../system/kernel/zen.nix
    ../../system/microcode/amd.nix
    ../../system/ryzen-smu.nix
  ];
}
