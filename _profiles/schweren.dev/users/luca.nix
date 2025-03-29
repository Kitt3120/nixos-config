{ config, pkgs, ... }:

{
  imports = [
    ./luca/ssh.nix
    ./luca/user.nix
    ./luca/services/minecraft-ayliincn.nix
  ];
}
