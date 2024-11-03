#!/usr/bin/env bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

sudo mv /etc/nixos /tmp/nixos-$DATE
sudo mkdir /etc/nixos
sudo cp -r ./* /etc/nixos
sudo rm -rf /etc/nixos/switch.sh /etc/nixos/.gitignore /etc/nixos/.git
sudo cp /tmp/nixos-$DATE/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
sudo chown root:root -R /etc/nixos/

sudo sudo nix-channel --update
sudo nixos-rebuild switch --upgrade-all |& nom
