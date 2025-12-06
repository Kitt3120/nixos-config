{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.settings.podman = {
    dockerMode = lib.mkOption {
      type = lib.types.bool;
      description = "Enable Docker compatibility mode (enables both dockerSocket and dockerCompat).";
    };
  };

  config = {
    virtualisation.podman = {
      enable = true;
      dockerSocket.enable = config.settings.podman.dockerMode;
      dockerCompat = config.settings.podman.dockerMode;
      defaultNetwork.settings.dns_enabled = true; # Enable DNS in podman compose
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [
          "--all"
          "--volumes"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      podman-compose
    ];

    environment.variables.PODMAN_COMPOSE_WARNING_LOGS = "false"; # Disable external provider warnings
  };
}
