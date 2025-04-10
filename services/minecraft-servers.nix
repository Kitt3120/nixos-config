{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.minecraft.servers = lib.mkOption {
    type = lib.types.listOf (lib.types.attrs);
  };

  config.home-manager.users = lib.foldl' (
    acc: server:
    acc
    // {
      ${server.user} = {
        home.packages = [
          (config.mkMinecraftServer server.name server.directory server.jarName server.java server.ram
            server.debug
          ).scripts.manager
          (config.mkMinecraftServer server.name server.directory server.jarName server.java server.ram
            server.debug
          ).scripts.start
          (config.mkMinecraftServer server.name server.directory server.jarName server.java server.ram
            server.debug
          ).scripts.stop
        ];
        systemd.user.services."minecraft-${server.name}" =
          (config.mkMinecraftServer server.name server.directory server.jarName server.java server.ram
            server.debug
          ).systemd.unit;
      };
    }
  ) { } config.minecraft.servers;

  config.networking.firewall = {
    allowedTCPPorts = lib.concatMap (server: server.ports.tcp) config.minecraft.servers;
    allowedUDPPorts = lib.concatMap (server: server.ports.udp) config.minecraft.servers;
  };
}
