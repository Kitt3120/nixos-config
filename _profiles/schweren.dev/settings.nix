{
  config,
  pkgs,
  lib,
  ...
}:

{
  settings = {
    sops.device-secrets = ../../secrets/schweren-dev.yaml;

    memoryAllocator = "libc";

    zramSwap = {
      enable = true;
      optimiseSysctl = true;
      algorithm = "zstd";
      priority = 5;
      memoryPercent = 50;
    };

    tor-relay = {
      ContactInfo = "tor@schweren.dev";
      Address = "schweren.dev";
      Nickname = "schweren";
      BandwidthRate = "10 MBytes";
      BandwidthBurst = "15 MBytes";
    };

    zabbix-agent = {
      server = "202.61.247.125";
      listen = {
        ip = "0.0.0.0";
        port = 10050;
      };
      openFirewall = true;
      allowDocker = true;
    };

    minecraft.servers = [
      {
        user = "minecraft";
        name = "mit-den-hoes";
        directory = "/home/minecraft/mit-den-hoes";
        jar = {
          url = "https://meta.fabricmc.net/v2/versions/loader/1.21.4/0.16.14/1.0.3/server/jar";
          hash = "sha256-xQdPurp4NNQ9m77QvhWXNeeYv+Tq9zXCXIJeZZ/iqwM=";
        };
        java = pkgs.jdk21;
        ram = "15G";
        debug = false;
        ports = {
          tcp = [
            25565
            8123
          ];
          udp = [ 24454 ];
        };
      }
    ];
  };
}
