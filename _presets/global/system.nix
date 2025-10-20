{ ... }:

{
  imports = [
    #../../system/autoUpgrade.nix # TODO: Enable again when fixed
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
    ../../system/zramSwap.nix
  ];
}
