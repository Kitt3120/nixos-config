{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wootility
    wooting-udev-rules
  ];

  hardware.wooting.enable = true;
}