{ config, pkgs, ... }:

{
  home-manager.users.minecraft.systemd.user.services.minecraft-mdj = {
    Unit = {
      Description = "Minecraft MDJ";
      After = [ "network.target" ];
      Wants = [ "network.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/home/minecraft/mdj";
      ExecStart = "/home/minecraft/mdj/systemd-start.sh";
      ExecStop = "/home/minecraft/mdj/systemd-stop.sh";
    };
    
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}