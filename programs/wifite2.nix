{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ wifite2 ];
}
