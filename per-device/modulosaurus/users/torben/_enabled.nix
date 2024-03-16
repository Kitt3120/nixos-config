{ config, pkgs, ... }:

{
  imports = [
    ./user.nix
    ./git.nix
  ];
}