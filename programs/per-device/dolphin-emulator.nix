{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ dolphin-emu ];
}