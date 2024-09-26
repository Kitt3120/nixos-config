#!/usr/bin/env bash

if [ ! -f "configuration.nix" ]; then
    echo "Please run this script from the root directory of the configuration"
    exit 1
fi

nixfmt --strict --verify .