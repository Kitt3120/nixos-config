{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xz ]; # Hopefully without backdoors :)
}