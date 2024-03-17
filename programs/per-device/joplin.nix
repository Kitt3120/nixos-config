{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ joplin-desktop ];
}