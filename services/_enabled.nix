{ config, pkgs, ... }:

{
  imports = [
    ./avahi.nix
    ./cups.nix
    ./dbus.nix
    ./fstrim.nix
    ./fwupd.nix
    ./logrotate.nix
    ./oomd.nix
    ./openssh.nix
    ./packagekit.nix
    ./timesyncd.nix
  ];
}
