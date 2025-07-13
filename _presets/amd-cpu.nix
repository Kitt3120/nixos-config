{ config, pkgs, ... }:

{
  imports = [
    ../system/microcode/amd.nix
    ../system/ryzen-smu.nix
  ];
}
