{ config, pkgs, ... }:

{
    boot.initrd.systemd.dbus.enable = true;

    environment.systemPackages = with pkgs; [
        dbus-broker
     ];
}