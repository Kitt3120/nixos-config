{ config, pkgs, ... }:

let
  minecraft = config.mkMinecraftFabricServer "adventure" "/home/minecraft/adventure" "fabric" pkgs.jdk21 "15G" false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.minecraft = {
    home.packages = [ minecraft.scripts.manager minecraft.scripts.start minecraft.scripts.stop ];
    systemd.user.services.minecraft-adventure = minecraft.systemd.unit;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 24454 ]; # Simple Voice Chat mod
}