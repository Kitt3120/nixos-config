{ config, pkgs, ... }:

{
  boot.loader.grub.enableCryptodisk = true;
}