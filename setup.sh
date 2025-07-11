#!/usr/bin/env bash

read -p "Which channel do you want to use?
1 - nixos-unstable
2 - nixos-unstable-small
3 - nixos-25.05
4 - https://github.com/NixOS/nixpkgs/archive/master.tar.gz

> " CHANNEL

case $CHANNEL in
  1)
    CHANNEL="https://channels.nixos.org/nixos-unstable"
    ;;
  2)
    CHANNEL="https://channels.nixos.org/nixos-unstable-small"
    ;;
  3)
    CHANNEL="https://channels.nixos.org/nixos-25.05"
    ;;
  4)
    CHANNEL="https://github.com/NixOS/nixpkgs/archive/master.tar.gz"
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac

sudo nix-channel --add $CHANNEL nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

git update-index --assume-unchanged settings.nix
git update-index --assume-unchanged _profiles/_enabled.nix
