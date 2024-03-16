{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ uwufetch ];
}