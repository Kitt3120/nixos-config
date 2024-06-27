{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ python3 python312Packages.pip ];
}