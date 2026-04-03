{ ... }:

{
  imports = [
    ../../services/avahi.nix
    ../../services/comin.nix
    #../../services/cups.nix # TODO: Enable again when fixed upstream
    ../../services/dbus.nix
    ../../services/fstrim.nix
    ../../services/fwupd.nix
    ../../services/logrotate.nix
    ../../services/oomd.nix
    ../../services/openssh.nix
    ../../services/packagekit.nix
    ../../services/timesyncd.nix
  ];
}
