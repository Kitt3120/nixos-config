{ config, pkgs, ... }:

{
  imports = [
    ../../system/bootloader/grub.nix
    ../../system/iio-sensor.nix
    ../../system/inputmodule.nix
    ../../system/kernel/modules/framework.nix
    ../../system/kernel/modules/xone.nix
    ../../system/kernel/zen.nix
  ];
}
