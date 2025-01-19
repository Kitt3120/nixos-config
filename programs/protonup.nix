{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonup
    protonup-qt
  ];
}
