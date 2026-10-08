{ config, pkgs, ... }:

let
  deploymentDir = "/var/lib/warpgate/warpgate";
  publicDomain = "warpgate.schweren.dev";

  proxyListenAddress = "172.17.0.1"; # Matches the Docker bridge binding
  proxyListenPort = 18080;

  image = {
    nextcloud = "docker.io/library/nextcloud:35.0.1-apache";
    postgres = "docker.io/library/postgres:18.4";
    redis = "docker.io/library/redis:8.4";
  };
in
{
  sops.secrets = {
    "warpgate/postgres-db" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "warpgate/postgres-user" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "warpgate/postgres-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "warpgate/nextcloud-admin-user" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "warpgate/nextcloud-admin-password" = {
      sopsFile = config.settings.sops.device-secrets;
    };
    "warpgate/trusted-proxy" = {
      sopsFile = config.settings.sops.device-secrets;
    };
  };

  sops.templates."warpgate-postgres.env" = {
    owner = "warpgate";
    mode = "0600";
    content = ''
      POSTGRES_DB=${config.sops.placeholder."warpgate/postgres-db"}
      POSTGRES_USER=${config.sops.placeholder."warpgate/postgres-user"}
      POSTGRES_PASSWORD=${config.sops.placeholder."warpgate/postgres-password"}
    '';
  };

  sops.templates."warpgate-nextcloud.env" = {
    owner = "warpgate";
    mode = "0600";
    content = ''
      POSTGRES_DB=${config.sops.placeholder."warpgate/postgres-db"}
      POSTGRES_USER=${config.sops.placeholder."warpgate/postgres-user"}
      POSTGRES_PASSWORD=${config.sops.placeholder."warpgate/postgres-password"}
      NEXTCLOUD_ADMIN_USER=${config.sops.placeholder."warpgate/nextcloud-admin-user"}
      NEXTCLOUD_ADMIN_PASSWORD=${config.sops.placeholder."warpgate/nextcloud-admin-password"}
      TRUSTED_PROXIES=${config.sops.placeholder."warpgate/trusted-proxy"}
    '';
  };

  settings.podman.deployments = [
    {
      name = "warpgate";
      user = "warpgate";
      shell = true;
      deploymentDirectory = deploymentDir;
      ports.tcp = [ proxyListenPort ];

      networks.warpgate = {
        quadlet.Network.NetworkName = "warpgate";
      };

      containers = {
        postgres = {
          networks = [ "warpgate" ];

          quadlet = {
            Unit.Description = "WarpGate PostgreSQL";
            Container = {
              Image = image.postgres;
              ContainerName = "warpgate-postgres";
              NetworkAlias = "warpgate-postgres";
              EnvironmentFile = config.sops.templates."warpgate-postgres.env".path;
              Volume = "${deploymentDir}/postgres:/var/lib/postgresql";
              ShmSize = "128mb";

              HealthCmd = ''pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"'';
              HealthInterval = "15s";
              HealthTimeout = "5s";
              HealthRetries = 8;
              HealthOnFailure = "kill";
              Notify = "healthy";
            };
          };
        };

        redis = {
          networks = [ "warpgate" ];

          quadlet = {
            Unit.Description = "WarpGate Redis cache and file locking";
            Container = {
              Image = image.redis;
              ContainerName = "warpgate-redis";
              NetworkAlias = "warpgate-redis";
              HealthCmd = "redis-cli ping";
              HealthInterval = "15s";
              HealthTimeout = "5s";
              HealthRetries = 5;
              HealthOnFailure = "kill";
              Notify = "healthy";
            };
          };
        };

        nextcloud = {
          networks = [ "warpgate" ];
          dependsOn = [
            "postgres"
            "redis"
          ];

          quadlet = {
            Unit.Description = "WarpGate Nextcloud";
            Container = {
              Image = image.nextcloud;
              ContainerName = "warpgate-nextcloud";
              EnvironmentFile = config.sops.templates."warpgate-nextcloud.env".path;
              Volume = "${deploymentDir}/nextcloud:/var/www/html";
              PublishPort = "${proxyListenAddress}:${toString proxyListenPort}:80";

              Environment = [
                "POSTGRES_HOST=warpgate-postgres"
                "NEXTCLOUD_TRUSTED_DOMAINS=${publicDomain}"
                "OVERWRITEHOST=${publicDomain}"
                "OVERWRITEPROTOCOL=https"
                "OVERWRITECLIURL=https://${publicDomain}"
                "NEXTCLOUD_INIT_HTACCESS=true"
                "REDIS_HOST=warpgate-redis"
                "PHP_MEMORY_LIMIT=1G"
                "PHP_UPLOAD_LIMIT=16G"
                "APACHE_BODY_LIMIT=0"
                "PHP_OPCACHE_MEMORY_CONSUMPTION=256"
                "APACHE_DISABLE_REWRITE_IP=1"
              ];

              # The image contains PHP; no additional healthcheck binaries.
              HealthCmd = "php -r 'exit(@file_get_contents(\"http://127.0.0.1/status.php\") === false ? 1 : 0);'";
              HealthInterval = "30s";
              HealthTimeout = "10s";
              HealthRetries = 6;
              HealthStartPeriod = "300s";
              HealthOnFailure = "kill";
              Notify = "healthy";
            };
          };
        };
      };
    }
  ];

  # Exactly one execution mechanism for Nextcloud's background jobs.
  # The timer runs in the same rootless user's systemd instance and uses
  # the running application container rather than a second copy of it.
  home-manager.users.warpgate.systemd.user.services."warpgate-cron" = {
    Unit = {
      Description = "WarpGate Nextcloud background jobs";
      Wants = [ "podman-deployment-warpgate-nextcloud.service" ];
      After = [ "podman-deployment-warpgate-nextcloud.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman exec --user 33 warpgate-nextcloud php -f /var/www/html/cron.php";
    };
  };

  home-manager.users.warpgate.systemd.user.timers."warpgate-cron" = {
    Unit.Description = "Run WarpGate Nextcloud background jobs every five minutes";
    Timer = {
      OnCalendar = "*-*-* *:0/5:00";
      Persistent = true;
      Unit = "warpgate-cron.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
