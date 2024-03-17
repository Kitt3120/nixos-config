{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ 
    retroarchFull
    retroarch-assets
   ];
}