{ config, pkgs, ... }:

{
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
}
