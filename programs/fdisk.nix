{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ unixtools.fdisk ];
}
