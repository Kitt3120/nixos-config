{ config, pkgs, ... }:

{
  services.zabbixAgent = {
    enable = true;
    package = pkgs.zabbix.agent2;
    server = config.zabbix.server;
    listen = config.zabbix.listen;
    openFirewall = true;
    settings = {
      "ServerActive" = config.zabbix.server;
    };
  };

  # Allow the zabbix-agent to access the docker socket
  users.users.zabbix-agent.extraGroups = [ "docker" ];
}