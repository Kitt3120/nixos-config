{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ maven ];
}
