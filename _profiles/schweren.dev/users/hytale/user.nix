{ config, ... }:

{
  sops.secrets."passwords/hytale" = {
    sopsFile = config.settings.sops.device-secrets;
    neededForUsers = true;
  };

  users.users.hytale = {
    isNormalUser = true;
    description = "Hytale";
    extraGroups = [
      "users"
      "networkmanager"
      "podman"
    ];
    createHome = true;
    linger = true;
    hashedPasswordFile = config.sops.secrets."passwords/hytale".path;
  };

  allUsers = [ "hytale" ];
}
