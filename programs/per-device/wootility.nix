{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wootility
    wooting-udev-rules
  ];
}