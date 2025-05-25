{ config, pkgs, ... }:

{
  imports = [
    ./minecraft/ssh.nix
    ./minecraft/user.nix
  ];
}
