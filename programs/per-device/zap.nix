{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ zap ];
}