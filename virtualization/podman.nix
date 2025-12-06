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
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [
          "--all"
          "--volumes"
        ];
      };
    };
  };
}
