{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.zabbix-agent = {
    server = lib.mkOption {
      type = lib.types.str;
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
    };

    listen = {
      ip = lib.mkOption {
        default = "0.0.0.0";
        type = lib.types.str;
      };

      port = lib.mkOption {
        default = 10050;
        type = lib.types.int;
      };
    };

    allowDocker = lib.mkOption {
      type = lib.types.bool;
    };
  };

  config = {
    services.zabbixAgent = {
      enable = true;
      package = pkgs.zabbix.agent2;
      server = config.zabbix-agent.server;
      listen = config.zabbix-agent.listen;
      openFirewall = config.zabbix-agent.openFirewall;
      settings = {
        "ServerActive" = config.zabbix-agent.server;
      };
    };

    # Allow the zabbix-agent to access the docker socket
    users.users.zabbix-agent.extraGroups = lib.mkIf config.zabbix-agent.allowDocker [ "docker" ];
  };
}
