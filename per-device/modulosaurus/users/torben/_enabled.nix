{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./ssh.nix
    ./user.nix
  ];
}