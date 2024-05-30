{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  });
}