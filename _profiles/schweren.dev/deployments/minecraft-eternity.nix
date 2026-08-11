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

  sops.templates."minecraft-eternity.env" = {
    content = ''
      REDIS_PASSWORD=${config.sops.placeholder."minecraft-eternity/redis-password"}
      POSTGRES_DB=${config.sops.placeholder."minecraft-eternity/postgres-db"}
      POSTGRES_USER=${config.sops.placeholder."minecraft-eternity/postgres-user"}
      POSTGRES_PASSWORD=${config.sops.placeholder."minecraft-eternity/postgres-password"}
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

        udp = [
          24454
        ];
      };
      preStart = ''
        cp -f ${
          config.sops.templates."minecraft-eternity.env".path
        } /var/lib/minecraft-eternity/eternity/.env
        chmod 600 /var/lib/minecraft-eternity/eternity/.env
      '';
      compose = ''
        networks:
          eternity:
            name: eternity

        services:
          redis:
            image: docker.io/library/redis:8
            restart: always
            command: redis-server --requirepass ''${REDIS_PASSWORD}
            networks:
              - eternity
            volumes:
              - ./redis:/data
            logging:
              driver: json-file
              options:
                max-size: "20m"

          postgres:
            image: docker.io/library/postgres:18.4
            restart: always
            shm_size: 128mb
            networks:
              - eternity
            environment:
              POSTGRES_DB: "''${POSTGRES_DB}"
              POSTGRES_USER: "''${POSTGRES_USER}"
              POSTGRES_PASSWORD: "''${POSTGRES_PASSWORD}"
            volumes:
              - ./postgres:/var/lib/postgresql
            logging:
              driver: json-file
              options:
                max-size: "20m"

          mariadb:
            image: docker.io/library/mariadb:12.3
            restart: always
            networks:
              - eternity
            environment:
              MARIADB_AUTO_UPGRADE: "true"
              MARIADB_ROOT_PASSWORD: "''${MARIADB_ROOT_PASSWORD}"
              MARIADB_DATABASE: "''${MARIADB_DATABASE}"
              MARIADB_USER: "''${MARIADB_USER}"
              MARIADB_PASSWORD: "''${MARIADB_PASSWORD}"
            volumes:
              - ./mariadb:/var/lib/mysql
            logging:
              driver: json-file
              options:
                max-size: "20m"

          eternity:
            image: docker.io/itzg/minecraft-server:latest
            restart: always
            tty: true
            stdin_open: true
            networks:
              - eternity
            depends_on:
              - redis
              - postgres
              - mariadb
            ports:
              - "25565:25565"
              - "172.17.0.1:8100:8100"
              - "24454:24454/udp"
            environment:
              UID: "0"
              GID: "0"
              TZ: "Europe/Berlin"
              TYPE: "LEAF"
              VERSION: "latest"
              MEMORY: "12G"
              EULA: "TRUE"
              VIEW_DISTANCE: "16"
              SIMULATION_DISTANCE: "16"
              SYNC_CHUNK_WRITES: "false"
              DIFFICULTY: "normal"
              MODE: "survival"
              ONLINE_MODE: "true"
              ENABLE_COMMAND_BLOCK: "true"
              ALLOW_FLIGHT: "true"
              MAX_PLAYERS: "10"
              ENABLE_RCON: "false"
              SPAWN_PROTECTION: "0"
              USE_AIKAR_FLAGS: "false"
              USE_MEOWICE_FLAGS: "true"
              SERVER_NAME: "Eternity"
              MOTD: "§6The server running for §5eternity§6. Started §529.07.2026§6."
              ICON: "https://cloud.schweren.dev/apps/files_sharing/publicpreview/kMHzyqTswdN9GER?file=/&fileId=8367804&x=3840&y=2160&a=true&etag=fa316cd23f8713936c4783760afadbcb"
              OVERRIDE_ICON: "true"
            volumes:
              - ./eternity:/data
            logging:
              driver: json-file
              options:
                max-size: "20m"
      '';
    }
  ];
}
