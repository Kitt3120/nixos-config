{ config, pkgs, ... }:

{
  imports = [
    ./user.nix
    ./ssh.nix
    ./git.nix
  ];
}