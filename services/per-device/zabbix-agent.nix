{ config, pkgs, ... }:

{
  services.zabbixAgent = {
    enable = true;
    package = pkgs.zabbix.agent2;
    server = config.zabbix.server;
    listen = config.zabbix.listen;
    openFirewall = true;
  };
}