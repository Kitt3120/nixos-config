{ config, pkgs, ... }:

{
  imports = [
    ./hydra/_enabled.nix
  ];
}