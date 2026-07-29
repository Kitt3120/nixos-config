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

          postgres:
            image: docker.io/library/postgres:18
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

          mariadb:
            image: docker.io/library/mariadb:12
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
              - "19132:19132/udp"
            environment:
              UID: "0"
              GID: "0"
              EULA: "TRUE"
              TYPE: "LEAF"
              SERVER_NAME: "eternity"
              ONLINE_MODE: "true"
              ENABLE_RCON: "false"
              SPAWN_PROTECTION: "0"
              SYNC_CHUNK_WRITES: "false"
            volumes:
              - ./eternity:/data
      '';
    }
  ];
}
