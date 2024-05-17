{ config, pkgs, ... }:

{
  imports = [
    ../../services/per-device/docker.nix
    ../../services/per-device/tor-relay.nix
    ../../services/per-device/vscode-server.nix
  ];
}
