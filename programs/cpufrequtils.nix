{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ cpufrequtils ];
}