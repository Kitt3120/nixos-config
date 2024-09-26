{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bitwarden-desktop ];
}
