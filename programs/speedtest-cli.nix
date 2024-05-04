{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ speedtest-cli ];
}