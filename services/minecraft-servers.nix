{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.settings.minecraft.servers = lib.mkOption {
    type = lib.types.listOf (lib.types.attrs);
  };

  config.home-manager.users = lib.foldl' (
    acc: server:
    acc
    // {
      ${server.user} = acc.${server.user} or { } // {
        home.packages = (acc.${server.user}.home.packages or [ ]) ++ [
          (config.mkMinecraftServer server.name server.directory server.jar.url server.jar.hash server.java
            server.ram
            server.debug
          ).scripts.cli
        ];

        systemd.user.services = (acc.${server.user}.systemd.user.services or { }) // {
          "minecraft-${server.name}" =
            (config.mkMinecraftServer server.name server.directory server.jar.url server.jar.hash server.java
              server.ram
              server.debug
            ).systemd.unit;
        };
      };
    }
  ) { } config.settings.minecraft.servers;

  config.networking.firewall = {
    allowedTCPPorts = lib.concatMap (server: server.ports.tcp) config.settings.minecraft.servers;
    allowedUDPPorts = lib.concatMap (server: server.ports.udp) config.settings.minecraft.servers;
  };
}
