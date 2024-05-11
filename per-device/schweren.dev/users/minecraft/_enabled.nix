{ config, pkgs, ... }:

{
  imports = [
    ./user.nix
    ./ssh.nix
  ];
}