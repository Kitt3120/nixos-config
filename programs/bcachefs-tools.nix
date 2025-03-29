{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bcachefs-tools ];
}
