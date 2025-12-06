{ config, ... }:

{
  sops.secrets."passwords/streamercraft" = {
    sopsFile = config.settings.sops.device-secrets;
    neededForUsers = true;
  };

  users.users.streamercraft = {
    isNormalUser = true;
    description = "Streamercraft";
    extraGroups = [
      "users"
      "networkmanager"
      "podman"
    ];
    createHome = true;
    linger = true;
    hashedPasswordFile = config.sops.secrets."passwords/streamercraft".path;
  };

  allUsers = [ "streamercraft" ];
}
