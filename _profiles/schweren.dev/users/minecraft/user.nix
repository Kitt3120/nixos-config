{
  config,
  lib,
  pkgs,
  ...
}:

{
  sops.secrets."passwords/minecraft" = {
    sopsFile = config.settings.sops.device-secrets;
    neededForUsers = true;
  };

  users.users.minecraft = {
    isNormalUser = true;
    description = "Minecraft";
    extraGroups = [
      "users"
      "networkmanager"
    ];
    createHome = true;
    linger = true;
    hashedPasswordFile = config.sops.secrets."passwords/minecraft".path;
  };

  allUsers = [ "minecraft" ];
}
