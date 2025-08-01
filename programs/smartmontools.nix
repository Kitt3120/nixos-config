{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ smartmontools ];
}
