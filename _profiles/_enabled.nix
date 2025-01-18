# Untrack this file from git by running
# git update-index --assume-unchanged _profiles/_enabled.nix
# or by running setup.sh
# Then set current device profile below

{ config, pkgs, ... }:

{
  imports = [
    #./hydra.nix
    #./modulosaurus.nix
    #./schweren.dev.nix
  ];
}
