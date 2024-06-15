{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ lshw ];
}