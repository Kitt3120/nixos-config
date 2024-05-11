{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ parallel ];
}