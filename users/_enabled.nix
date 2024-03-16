{ config, pkgs, ... }:

{
  imports = [
    ./functions/_enabled.nix

    ./allUsers.nix
    ./immutable.nix
    ./xdg.nix
  ];
}