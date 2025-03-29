{ config, pkgs, ... }:

let
  ayliincn =
    config.mkMinecraftServer "ayliincn" "/home/luca/ayliincn" "paper" pkgs.jdk21 "10G"
      false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.luca = {
    home.packages = [
      ayliincn.scripts.manager
      ayliincn.scripts.start
      ayliincn.scripts.stop
    ];
    systemd.user.services.minecraft-ayliincn = ayliincn.systemd.unit;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 19132 ];
}
