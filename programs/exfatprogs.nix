{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ exfatprogs ];
}
