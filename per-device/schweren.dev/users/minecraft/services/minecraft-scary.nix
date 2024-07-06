{ config, pkgs, ... }:

let
  scary = config.mkMinecraftFabricServer "scary" "/home/minecraft/scary" "fabric" pkgs.jdk17 "10G" false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.minecraft = {
    home.packages = [ scary.scripts.manager scary.scripts.start scary.scripts.stop ];
    systemd.user.services.minecraft-scary = scary.systemd.unit;
  };
}