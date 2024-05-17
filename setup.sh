#!/usr/bin/env bash

sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

git update-index --assume-unchanged settings.nix
git update-index --assume-unchanged per-device/_enabled.nix