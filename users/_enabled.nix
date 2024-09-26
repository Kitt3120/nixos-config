{ config, pkgs, ... }:

{
  imports = [
    ./allUsers.nix
    ./immutable.nix
    ./xdg.nix
  ];
}
