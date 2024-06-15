# Untrack this file from git by running
# git update-index --assume-unchanged per-device/_enabled.nix
# or by running setup.sh
# Then set current device profile below

{ config, pkgs, ... }:

{
  imports = [
    #./hydra/_enabled.nix
    #./modulosaurus/_enabled.nix
    #./schweren.dev/_enabled.nix
  ];
}
