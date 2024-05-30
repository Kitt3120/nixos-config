{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ aria2 ];
}