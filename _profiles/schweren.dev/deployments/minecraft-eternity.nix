{ config, ... }:

{
  sops.secrets = {
    "minecraft-eternity/redis-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/postgres-db" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/postgres-user" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/postgres-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/mariadb-root-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/mariadb-database" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/mariadb-user" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "minecraft-eternity/mariadb-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
  };

  # Separate per-container templates so that e.g. Redis never sees the PostgreSQL/MariaDB
  # credentials and vice versa.
  sops.templates."minecraft-eternity-redis.env" = {
    content = ''
      REDIS_PASSWORD=${config.sops.placeholder."minecraft-eternity/redis-password"}
    '';
    owner = "minecraft-eternity";
    mode = "0600";
  };

  sops.templates."minecraft-eternity-postgres.env" = {
    content = ''
      POSTGRES_DB=${config.sops.placeholder."minecraft-eternity/postgres-db"}
      POSTGRES_USER=${config.sops.placeholder."minecraft-eternity/postgres-user"}
      POSTGRES_PASSWORD=${config.sops.placeholder."minecraft-eternity/postgres-password"}
    '';
    owner = "minecraft-eternity";
    mode = "0600";
  };

  sops.templates."minecraft-eternity-mariadb.env" = {
    content = ''
      MARIADB_ROOT_PASSWORD=${config.sops.placeholder."minecraft-eternity/mariadb-root-password"}
      MARIADB_DATABASE=${config.sops.placeholder."minecraft-eternity/mariadb-database"}
      MARIADB_USER=${config.sops.placeholder."minecraft-eternity/mariadb-user"}
      MARIADB_PASSWORD=${config.sops.placeholder."minecraft-eternity/mariadb-password"}
    '';
    owner = "minecraft-eternity";
    mode = "0600";
  };

  settings.podman.deployments = [
    {
      name = "eternity";
      user = "minecraft-eternity";
      shell = true;

      ports = {
        tcp = [
          25565
          8100
        ];

        udp = [ 24454 ];
      };

      networks = {
        # Keep the existing, explicit network name so the migration doesn't require recreating it.
        eternity = {
          quadlet = {
            Network = {
              NetworkName = "eternity";
            };
          };
        };
      };

      containers = {
        redis = {
          networks = [ "eternity" ];

          quadlet = {
            Unit = {
              Description = "Eternity Redis";
            };

            Container = {
              Image = "docker.io/library/redis:8";
              # Avoid putting the secret on the host podman command line; expand it inside the
              # container's own shell instead, sourced from EnvironmentFile.
              Exec = ''/bin/sh -c "exec redis-server --requirepass \"$REDIS_PASSWORD\""'';
              EnvironmentFile = config.sops.templates."minecraft-eternity-redis.env".path;
              Volume = "/var/lib/minecraft-eternity/eternity/redis:/data";

              HealthCmd = ''/bin/sh -c "redis-cli -a \"$REDIS_PASSWORD\" --no-auth-warning ping | grep PONG"'';
              HealthInterval = "10s";
              HealthTimeout = "5s";
              HealthRetries = 5;
              HealthOnFailure = "kill";
              Notify = "healthy";
            };
          };
        };

        postgres = {
          networks = [ "eternity" ];

          quadlet = {
            Unit = {
              Description = "Eternity PostgreSQL";
            };

            Container = {
              Image = "docker.io/library/postgres:18.4";
              ShmSize = "128mb";
              EnvironmentFile = config.sops.templates."minecraft-eternity-postgres.env".path;
              Volume = "/var/lib/minecraft-eternity/eternity/postgres:/var/lib/postgresql";

              HealthCmd = ''/bin/sh -c "pg_isready -U \"$POSTGRES_USER\" -d \"$POSTGRES_DB\""'';
              HealthInterval = "10s";
              HealthTimeout = "5s";
              HealthRetries = 5;
              HealthOnFailure = "kill";
              Notify = "healthy";
            };
          };
        };

        mariadb = {
          networks = [ "eternity" ];

          quadlet = {
            Unit = {
              Description = "Eternity MariaDB";
            };

            Container = {
              Image = "docker.io/library/mariadb:12.3";
              Environment = [ "MARIADB_AUTO_UPGRADE=true" ];
              EnvironmentFile = config.sops.templates."minecraft-eternity-mariadb.env".path;
              Volume = "/var/lib/minecraft-eternity/eternity/mariadb:/var/lib/mysql";

              HealthCmd = "healthcheck.sh --connect --innodb_initialized";
              HealthInterval = "10s";
              HealthTimeout = "5s";
              HealthRetries = 5;
              HealthOnFailure = "kill";
              Notify = "healthy";
            };
          };
        };

        eternity = {
          networks = [ "eternity" ];
          dependsOn = [
            "redis"
            "postgres"
            "mariadb"
          ];

          quadlet = {
            Unit = {
              Description = "Eternity Minecraft server";
            };

            Container = {
              Image = "docker.io/itzg/minecraft-server:latest";
              Volume = "/var/lib/minecraft-eternity/eternity/eternity:/data";

              # Preserves the previous compose `tty: true` / `stdin_open: true` so attaching to
              # the console keeps working (ENABLE_RCON is disabled below).
              PodmanArgs = [
                "--tty"
                "--interactive"
              ];

              PublishPort = [
                "25565:25565"
                "172.17.0.1:8100:8100"
                "24454:24454/udp"
              ];

              Environment = [
                "UID=0"
                "GID=0"
                "TZ=Europe/Berlin"
                "TYPE=LEAF"
                "VERSION=latest"
                "MEMORY=12G"
                "EULA=TRUE"
                "VIEW_DISTANCE=16"
                "SIMULATION_DISTANCE=10"
                "SYNC_CHUNK_WRITES=false"
                "DIFFICULTY=normal"
                "MODE=survival"
                "ONLINE_MODE=true"
                "ENABLE_COMMAND_BLOCK=true"
                "ALLOW_FLIGHT=true"
                "MAX_PLAYERS=10"
                "ENABLE_RCON=false"
                "SPAWN_PROTECTION=0"
                "USE_AIKAR_FLAGS=false"
                "USE_MEOWICE_FLAGS=true"
                "SERVER_NAME=Eternity"
                "MOTD=§6The server running for §5eternity§6. Started §529.07.2026§6."
                "ICON=https://cloud.schweren.dev/apps/files_sharing/publicpreview/kMHzyqTswdN9GER?file=/&fileId=8367804&x=3840&y=2160&a=true&etag=fa316cd23f8713936c4783760afadbcb"
                "OVERRIDE_ICON=true"
              ];
            };
          };
        };
      };
    }
  ];
}
