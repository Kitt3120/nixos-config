{ config, pkgs, ... }:

{
  imports = [
    ./mailcow.nix
    ./satisfactory.nix
  ];
}
