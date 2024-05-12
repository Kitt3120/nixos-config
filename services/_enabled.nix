{ config, pkgs, ... }:

{
  imports = [
    ./dbus.nix
    ./fwupd.nix
    ./fstrim.nix
    ./openssh.nix
    ./avahi.nix
    ./timesyncd.nix
    ./oomd.nix
    ./logrotate.nix
    #./smartd.nix # TODO: Enable again
    ./packagekit.nix
    ./cups.nix
  ];
}