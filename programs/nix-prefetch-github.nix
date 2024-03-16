{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nix-prefetch-github ];
}