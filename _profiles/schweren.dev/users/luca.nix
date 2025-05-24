{ config, pkgs, ... }:

{
  imports = [
    ./luca/ssh.nix
    ./luca/user.nix
  ];
}
