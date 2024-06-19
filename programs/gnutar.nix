{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gnutar ];
}