{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ btrfs-progs ];
}