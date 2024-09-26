{ config, pkgs, ... }:

{
  imports = [
    ../../../services/avahi.nix
    ../../../services/cups.nix
    ../../../services/dbus.nix
    ../../../services/fstrim.nix
    ../../../services/fwupd.nix
    ../../../services/logrotate.nix
    ../../../services/oomd.nix
    ../../../services/openssh.nix
    ../../../services/packagekit.nix
    ../../../services/timesyncd.nix
  ];
}
