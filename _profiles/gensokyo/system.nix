{ ... }:

{
  imports = [
    ../../system/bootloader/grub.nix
    ../../system/kernel/modules/framework.nix
    ../../system/kernel/zen.nix
  ];
}