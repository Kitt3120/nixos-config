{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ cpupower-gui ];

  # Enables dbus/systemd service needed by cpupower-gui.
  # These services are responsible for retrieving and modifying cpu power saving settings.
  services.cpupower-gui.enable = true;
}
