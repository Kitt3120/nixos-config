{ pkgs, ... }:

{
  boot.initrd.systemd.dbus.enable = true;
  services.dbus = {
    enable = true;
    implementation = "broker";
  };
}
