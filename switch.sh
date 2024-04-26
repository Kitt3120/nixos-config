#!/bin/sh

# If Discord is installed, get its hash to later check if it was modified
DISCORD_PATH="/run/current-system/sw/bin/discord"
DISCORD_INSTALLED=$(test -f "$DISCORD_PATH" && echo "true" || echo "false")
if [ "$DISCORD_INSTALLED" = "true" ]; then
    REAL_PATH=$(realpath "$DISCORD_PATH")
    DISCORD_HASH=$(sha256sum "$REAL_PATH" | cut -d ' ' -f 1)
fi

sudo mv /etc/nixos/hardware-configuration.nix /tmp/
sudo rm -rf /etc/nixos/*
sudo cp -r ./* /etc/nixos
sudo rm -rf /etc/nixos/switch.sh /etc/nixos/.gitignore /etc/nixos/.git
sudo mv /tmp/hardware-configuration.nix /etc/nixos/
sudo chown root:root -R /etc/nixos/

sudo sudo nix-channel --update
sudo nixos-rebuild switch --upgrade-all

# Check if Discord is now installed and if hashes differ
if [ -f "$DISCORD_PATH" ]; then
    REAL_PATH=$(realpath "$DISCORD_PATH")
    DISCORD_HASH_NEW=$(sha256sum "$REAL_PATH" | cut -d ' ' -f 1)

    if [ "$DISCORD_HASH" != "$DISCORD_HASH_NEW" ]; then
        echo "Discord was modified"
        echo "Old hash: $DISCORD_HASH"
        echo "New hash: $DISCORD_HASH_NEW"
        echo "Applying Krisp patch"
        nix --extra-experimental-features nix-command --extra-experimental-features flakes run --refresh "github:steinerkelvin/dotfiles#discord-krisp-patch"
    fi
fi