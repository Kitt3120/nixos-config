{ config, pkgs, ... }:

{
  imports = [
    #./modulosaurus/_enabled.nix
    ./hydra/_enabled.nix
  ];
}