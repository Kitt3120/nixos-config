{ config, pkgs, ... }:

{
  imports = [
    #./hydra/_enabled.nix
    #./schweren.dev/_enabled.nix
  ];
}