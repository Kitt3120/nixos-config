{ config, ... }:

{
  sops.secrets = {
    "zomboid/server-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "zomboid/admin-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
  };

  sops.templates."zomboid.env" = {
    content = ''
      SERVER_PASSWORD=${config.sops.placeholder."zomboid/server-password"}
      ADMIN_PASSWORD=${config.sops.placeholder."zomboid/admin-password"}
    '';
    owner = "zomboid";
    mode = "0600";
  };

  settings.podman.deployments = [
    {
      name = "zomboid";
      user = "zomboid";
      shell = true;

      ports.udp = [
        16261
        16262
      ];

      containers.zomboid = {
        quadlet = {
          Unit = {
            Description = "Project Zomboid server";
          };

          Container = {
            Image = "docker.io/renegademaster/zomboid-dedicated-server:latest";

            EnvironmentFile = config.sops.templates."zomboid.env".path;

            Environment = [
              "TZ=Europe/Berlin"
              "SERVER_NAME=ZomboidServer"
              "ADMIN_USERNAME=admin"
              "GAME_VERSION=public"
              "MAX_PLAYERS=8"
              "MAX_RAM=8192m"
              "AUTOSAVE_INTERVAL=15"
              "PAUSE_ON_EMPTY=true"
              "STEAM_VAC=false"
              "USE_STEAM=true"
              "PUBLIC_SERVER=true"
              "DEFAULT_PORT=16261"
              "UDP_PORT=16262"
            ];

            PublishPort = [
              "16261:16261/udp"
              "16262:16262/udp"
            ];

            Volume = [
              "/var/lib/zomboid/zomboid/ZomboidDedicatedServer:/home/steam/ZomboidDedicatedServer"
              "/var/lib/zomboid/zomboid/ZomboidConfig:/home/steam/Zomboid"
            ];
          };
        };
      };
    }
  ];
}
