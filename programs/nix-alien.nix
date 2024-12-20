{ config, pkgs, ... }:

# TODO: Add nix-alien to nixpkgs
let
  nix-alien-pkgs =
    import (builtins.fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master")
      { };
in
{
  environment.systemPackages = with nix-alien-pkgs; [
    nix-alien
  ];
}
