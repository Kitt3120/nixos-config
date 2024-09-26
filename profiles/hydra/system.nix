{ config, pkgs, ... }:

{
  imports = [
    ../../system/bootloader/grub-cryptodisk.nix
    ../../system/bootloader/grub-memtest.nix
    ../../system/bootloader/grub-osprober.nix
    ../../system/bootloader/grub.nix
    ../../system/iio-sensor.nix
    #../../system/inputmodule.nix # TODO: Enable again when merged
    ../../system/kernel/modules/framework.nix
    ../../system/kernel/modules/xone.nix
    ../../system/kernel/zen.nix
    ../../system/microcode/amd.nix
    ../../system/ryzen-smu.nix
  ];
}
