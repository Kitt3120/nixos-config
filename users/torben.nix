{ config, pkgs, ... }:

{
  imports = [
    ./torben/git.nix
    ./torben/ssh.nix
    ./torben/user.nix
  ];
}
