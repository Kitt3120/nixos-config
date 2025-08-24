{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nettools ];
}
