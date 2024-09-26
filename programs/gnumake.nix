{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gnumake ];
}
