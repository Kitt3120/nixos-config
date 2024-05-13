{ config, pkgs, ... }:

{
  imports = [
    ./services/_enabled.nix
    ./user.nix
    ./ssh.nix
  ];
}