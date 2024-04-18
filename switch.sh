#!/bin/sh
sudo mv /etc/nixos/hardware-configuration.nix /tmp/
sudo rm -rf /etc/nixos/*
sudo cp -r ./* /etc/nixos
sudo rm -rf /etc/nixos/switch.sh /etc/nixos/.gitignore /etc/nixos/.git
sudo mv /tmp/hardware-configuration.nix /etc/nixos/
sudo chown root:root -R /etc/nixos/

sudo sudo nix-channel --update
sudo nixos-rebuild switch --upgrade-all
