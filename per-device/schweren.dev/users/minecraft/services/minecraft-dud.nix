{ config, pkgs, ... }:

let
  minecraft =
    config.mkMinecraftFabricServer "dud" "/home/minecraft/dud" "fabric" pkgs.jdk21 "7G"
      false; # TODO: Put Minecraft servers into settings
in
{
  home-manager.users.minecraft = {
    home.packages = [
      minecraft.scripts.manager
      minecraft.scripts.start
      minecraft.scripts.stop
    ];
    systemd.user.services.minecraft-dud = minecraft.systemd.unit;
  };

  networking.firewall.allowedTCPPorts = [ 25566 ];
}
