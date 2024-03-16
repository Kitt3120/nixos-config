{ config, pkgs, ... }:

{
  imports = [
    ./fstrim.nix
    ./cups.nix
    ./openssh.nix
    ./avahi.nix
    ./dbus.nix
    ./timesyncd.nix
    ./logrotate.nix
    ./oomd.nix
    #./smartd.nix # TODO: Enable again
    ./packagekit.nix
  ];
}