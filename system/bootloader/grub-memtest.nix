{ config, pkgs, ... }:

{
  boot.loader.grub.memtest86.enable = true;
}
