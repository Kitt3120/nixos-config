{ ... }:

{
  imports = [
    ../../services/minecraft-servers.nix
    ../../services/tor-relay.nix
    ../../services/vscode-server.nix
    ../../services/zabbix-agent.nix
  ];
}
