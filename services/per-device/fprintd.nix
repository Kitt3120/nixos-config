{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ libfprint ];
  services.fprintd.enable = true;
}