{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ libfprint ];
  services.fprintd.enable = true;

  security.pam.services.login.fprintAuth = false;
}