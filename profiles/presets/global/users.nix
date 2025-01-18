{ config, pkgs, ... }:

{
  imports = [
    ../../../users/allUsers.nix
    ../../../users/immutable.nix
    ../../../users/xdg.nix

    ../../../users/torben.nix
  ];
}
