{ config, pkgs, ... }:

let
  mdj = config.mkMinecraftForgeServer "mdj" "/home/minecraft/mdj" "1.20.1-47.2.30" pkgs.jdk17 "5G" false;
in
{
  home-manager.users.minecraft = {
    home.packages = [ mdj.scripts.manager mdj.scripts.start mdj.scripts.stop ];
    systemd.user.services.minecraft-mdj = mdj.systemd.unit;
  };
}