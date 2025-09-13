{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ inxi ];
}
