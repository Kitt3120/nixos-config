#!/usr/bin/env bash

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
PREVIOUS_NIX_STORE_PATH=$(readlink /run/current-system/sw)

sudo mv /etc/nixos /tmp/nixos-$DATE
sudo mkdir /etc/nixos
sudo cp -r ./* /etc/nixos
sudo rm -rf /etc/nixos/switch.sh /etc/nixos/.gitignore /etc/nixos/.git
sudo cp /tmp/nixos-$DATE/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
sudo chown root:root -R /etc/nixos/

sudo sudo nix-channel --update

NIX_OUTPUT_MONITOR_INSTALLED=$(command -v nom)
if [ -x "$NIX_OUTPUT_MONITOR_INSTALLED" ]; then
  sudo nixos-rebuild switch --upgrade-all |& nom
else
  nix-shell -p nix-output-monitor --run "sudo nixos-rebuild switch --upgrade-all |& nom"
fi

NEW_NIX_STORE_PATH=$(readlink /run/current-system/sw)
NIX_VERSION_DIFF_INSTALLED=$(command -v nvd)
if [ -x "$NIX_VERSION_DIFF_INSTALLED" ]; then
  nvd diff "$PREVIOUS_NIX_STORE_PATH" "$NEW_NIX_STORE_PATH"
else
  nix-shell -p nvd --run "nvd diff \"$PREVIOUS_NIX_STORE_PATH\" \"$NEW_NIX_STORE_PATH\""
fi