{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ brave ];
}
