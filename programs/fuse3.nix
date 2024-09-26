{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ fuse3 ];
}
