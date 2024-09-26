{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ framework-tool ];
}
