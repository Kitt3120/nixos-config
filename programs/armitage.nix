{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ armitage ];
}
