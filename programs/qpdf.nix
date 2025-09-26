{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qpdf ];
}
