{ config, pkgs, ... }:

{
  imports = [
    ../../../system/autoUpgrade.nix
    ../../../system/firmware.nix
    ../../../system/locale.nix
    ../../../system/networking.nix
    ../../../system/nixgc.nix
    ../../../system/polkit.nix
    ../../../system/time.nix
    ../../../system/tmp.nix
    ../../../system/ulimit.nix
  ];
}
