{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.settings.zabbix-agent = {
    server = lib.mkOption {
      type = lib.types.str;
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

    openFirewall = lib.mkOption {
      type = lib.types.bool;
    };

    allowDocker = lib.mkOption {
      type = lib.types.bool;
    };
  };

  config = {
    services.zabbixAgent = {
      enable = true;
      package = pkgs.zabbix.agent2;
      server = config.settings.zabbix-agent.server;
      listen = config.settings.zabbix-agent.listen;
      openFirewall = config.settings.zabbix-agent.openFirewall;
      settings = {
        "ServerActive" = config.settings.zabbix-agent.server;
      };
    };

    # Allow the zabbix-agent to access the docker socket
    users.users.zabbix-agent.extraGroups = lib.mkIf config.settings.zabbix-agent.allowDocker [
      "docker"
    ];
  };
}
