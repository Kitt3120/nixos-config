{ config, ... }:

{
  sops.secrets."passwords/torben".neededForUsers = true;

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
      "render"
      "input"
      "optical"
      "scanner"
      "games"
      "i2c"
    ];
    createHome = true;
    linger = true;
    hashedPasswordFile = config.sops.secrets."passwords/torben".path;
  };

  allUsers = [ "torben" ];
}
