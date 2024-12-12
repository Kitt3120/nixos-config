{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xfsprogs ];
}
