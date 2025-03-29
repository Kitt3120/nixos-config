{ config, pkgs, ... }:

{
  imports = [
    ./users/luca.nix
    ./users/minecraft.nix
  ];
}
