{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        dbus
        dbus-broker
     ];
}