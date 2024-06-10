{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ tldr ];
}