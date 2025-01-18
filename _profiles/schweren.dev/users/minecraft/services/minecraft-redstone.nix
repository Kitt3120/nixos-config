{ config, pkgs, ... }:

let
  minecraft =
    config.mkMinecraftFabricServer "redstone" "/home/minecraft/redstone" "fabric" pkgs.jdk21 "10G"
      false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.minecraft = {
    home.packages = [
      minecraft.scripts.manager
      minecraft.scripts.start
      minecraft.scripts.stop
    ];
    systemd.user.services.minecraft-redstone = minecraft.systemd.unit;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 24454 ]; # Simple Voice Chat mod
}
