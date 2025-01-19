{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.credentials.user.torben.hashedPassword = lib.mkOption {
    type = lib.types.str;
    description = "The hashed password for the user torben";
  };

  config = {
    users.users.torben = {
      isNormalUser = true;
      description = "Torben Schweren";
      extraGroups = [
        "users"
        "wheel"
        "networkmanager"
        "kvm"
        "libvirt"
        "libvirt-qemu"
        "libvirtd"
        "docker"
        "gamemode"
        "audio"
        "video"
        "input"
        "optical"
        "scanner"
        "games"
        "i2c"
      ];
      createHome = true;
      linger = true;
      hashedPassword = config.credentials.user.torben.hashedPassword;
    };

    allUsers = [ "torben" ];
  };
}
