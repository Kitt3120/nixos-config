{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vivaldi ];
}
