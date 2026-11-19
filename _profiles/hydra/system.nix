{ ... }:

{
  imports = [
    ../../system/bootloader/grub.nix
    ../../system/inputmodule.nix
    ../../system/kernel/modules/xone.nix
    ../../system/kernel/zen.nix
  ];
}
