{ config, pkgs, ... }:

{
  imports = [
    ../../services/tor-relay.nix
    ../../services/vscode-server.nix
    ../../services/zabbix-agent.nix
  ];
}
