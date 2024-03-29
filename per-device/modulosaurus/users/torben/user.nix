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
      "docker"
      "gamemode"
      "audio"
      "video"
      "input"
      "optical"
      "scanner"
      "games"
    ];
    createHome = true;
    linger = true;
    hashedPassword = config.credentials.torben.hashedPassword;
  };

  allUsers = [ "torben" ];
}
