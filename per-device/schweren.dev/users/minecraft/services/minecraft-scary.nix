{ config, pkgs, ... }:

let
  scary = config.mkMinecraftFabricServer "scary" "/home/minecraft/scary" "fabric" pkgs.jdk21 "10G" false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.minecraft = {
    home.packages = [ scary.scripts.manager scary.scripts.start scary.scripts.stop ];
    systemd.user.services.minecraft-scary = scary.systemd.unit;
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 24454 ]; # Simple Voice Chat mod
}