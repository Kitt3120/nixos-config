{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    webcord-vencord
    arrpc
  ];
}
