{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.credentials.user.luca.hashedPassword = lib.mkOption {
    type = lib.types.str;
  };

  config = {
    users.users.luca = {
      isNormalUser = true;
      description = "Luca";
      extraGroups = [
        "users"
        "networkmanager"
      ];
      createHome = true;
      linger = true;
      hashedPassword = config.credentials.user.luca.hashedPassword;
    };

    allUsers = [ "luca" ];
  };
}
