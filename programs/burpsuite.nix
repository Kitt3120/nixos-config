{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ burpsuite ];
}
