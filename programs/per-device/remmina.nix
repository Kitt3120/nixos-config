{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ remmina ];
}
