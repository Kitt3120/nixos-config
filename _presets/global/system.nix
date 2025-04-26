{ config, pkgs, ... }:

{
  imports = [
    ../../system/autoUpgrade.nix
    ../../system/firmware.nix
    ../../system/i2c.nix
    ../../system/locale.nix
    ../../system/memoryAllocator.nix
    ../../system/networking.nix
    ../../system/nixgc.nix
    ../../system/polkit.nix
    ../../system/time.nix
    ../../system/tmp.nix
    ../../system/ulimit.nix
  ];
}
