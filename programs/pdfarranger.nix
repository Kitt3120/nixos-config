{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pdfarranger ];
}
