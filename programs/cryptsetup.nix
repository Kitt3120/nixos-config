{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ cryptsetup ];
}
