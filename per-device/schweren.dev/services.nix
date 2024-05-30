{ config, pkgs, ... }:

{
  imports = [
    ../../services/per-device/tor-relay.nix
    ../../services/per-device/vscode-server.nix
  ];
}
