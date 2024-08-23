{ config, pkgs, ... }:

{
  imports = [
    ../../services/per-device/tor-relay.nix
    ../../services/per-device/vscode-server.nix
    ../../services/per-device/zabbix-agent.nix
  ];
}
