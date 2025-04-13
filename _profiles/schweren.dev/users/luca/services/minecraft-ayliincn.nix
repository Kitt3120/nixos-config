{ config, pkgs, ... }:

let
  ayliincn =
    config.mkMinecraftServer "ayliincn" "/home/luca/ayliincn"
      "https://api.papermc.io/v2/projects/paper/versions/1.21.4/builds/224/downloads/paper-1.21.4-224.jar"
      "sha256-DN5RmWlReUorNF95au0FBuWuDeslqwhDGWf2NkTihxc="
      pkgs.jdk21
      "15G"
      false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.luca = {
    home.packages = [
      ayliincn.scripts.cli
      ayliincn.scripts.start
      ayliincn.scripts.stop
    ];
    systemd.user.services.minecraft-ayliincn = ayliincn.systemd.unit;
  };

  networking.firewall.allowedTCPPorts = [
    8123 # Dynmap
    25565 # Minecraft
  ];
  networking.firewall.allowedUDPPorts = [
    19132 # GeyserMC
  ];
}
