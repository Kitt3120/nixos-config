{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ kdePackages.plasma-disks ];
}
