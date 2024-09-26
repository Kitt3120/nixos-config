{ config, pkgs, ... }:

{
  boot.loader.grub.useOSProber = true;
}
