{ config, pkgs, ... }:

{
  imports = [
    ./torben/_enabled.nix
    ./minecraft/_enabled.nix
  ];
}