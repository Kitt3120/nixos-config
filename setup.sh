#!/usr/bin/env bash

read -p "Which channel do you want to use?
1 - nixos-unstable
2 - nixos-unstable-small
3 - nixos-24.11

> " CHANNEL

case $CHANNEL in
  1)
    CHANNEL="https://channels.nixos.org/nixos-unstable"
    ;;
  2)
    CHANNEL="https://channels.nixos.org/nixos-unstable-small"
    ;;
  3)
    CHANNEL="https://channels.nixos.org/nixos-24.11"
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac

sudo nix-channel --add $CHANNEL nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

git update-index --assume-unchanged settings.nix
git update-index --assume-unchanged profiles/_enabled.nix
