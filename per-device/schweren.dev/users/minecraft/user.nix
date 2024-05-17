{ config, pkgs, ... }:

{
  users.users.minecraft = {
    isNormalUser = true;
    description = "Minecraft";
    extraGroups = [
      "users"
      "networkmanager"
    ];
    createHome = true;
    linger = true;
    hashedPassword = config.credentials.user.minecraft.hashedPassword;
  };

  allUsers = [ "minecraft" ];
}
