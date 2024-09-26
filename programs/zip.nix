{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ zip ];
}
