{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ cpupower-gui ];

  # Enables dbus/systemd service needed by cpupower-gui.
  services.cpupower-gui.enable = true;
}
