{ config, pkgs, ... }:

{
  imports = [
    ../../system/per-device/bootloader/grub-cryptodisk.nix
    ../../system/per-device/bootloader/grub-memtest.nix
    ../../system/per-device/bootloader/grub-osprober.nix
    ../../system/per-device/bootloader/grub.nix
    ../../system/per-device/iio-sensor.nix
    #../../system/per-device/inputmodule.nix # TODO: Enable again when merged
    ../../system/per-device/kernel/modules/framework.nix
    ../../system/per-device/kernel/modules/xone.nix
    ../../system/per-device/kernel/zen.nix
    ../../system/per-device/microcode/amd.nix
    ../../system/per-device/ryzen-smu.nix
  ];
}