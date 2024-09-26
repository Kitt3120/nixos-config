{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ mdk4 ];
}
