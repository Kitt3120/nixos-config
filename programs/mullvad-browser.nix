{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ mullvad-browser ];
}
