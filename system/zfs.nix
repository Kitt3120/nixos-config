{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    settings.zfs = {
      hostId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Host ID used for ZFS pools.";
      };

      allowHibernation = lib.mkOption {
        type = lib.types.bool;
        description = "Allow ZFS to hibernate the system. Only enable if you have a swap partition outside of ZFS.";
      };

      pools = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };

      autoTrim = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Enable automatic invocation of zpool trim command";
        };

        interval = lib.mkOption {
          type = lib.types.str;
          description = "Interval for automatic ZFS trimming. Systemd format is used for scheduling (e.g., daily, weekly, monthly).";
        };

        randomizedDelaySec = lib.mkOption {
          type = lib.types.str;
          description = "Add a randomized delay before each ZFS trim. The delay will be chosen between zero and this value. Systemd format is used (e.g., 30s, 1m, 2h).";
        };
      };

      autoScrub = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Enable automatic scrubbing of ZFS pools";
        };

        pools = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "List of ZFS pools to scrub automatically";
        };

        interval = lib.mkOption {
          type = lib.types.str;
          description = "Interval for automatic scrubbing. Systemd format is used for scheduling (e.g., daily, weekly, monthly).";
        };

        randomizedDelaySec = lib.mkOption {
          type = lib.types.str;
          description = "Add a randomized delay before each ZFS autoscrub. The delay will be chosen between zero and this value. Systemd format is used (e.g., 30s, 1m, 2h).";
        };
      };

      autoSnapshot = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Enable automatic snapshots of ZFS datasets";
        };

        flags = lib.mkOption {
          type = lib.types.str;
          description = "Flags to pass to zfs snapshot command for automatic snapshots";
        };

        frequent = lib.mkOption {
          type = lib.types.int;
          description = "Number of frequent (15-minute) auto-snapshots to keep";
        };

        hourly = lib.mkOption {
          type = lib.types.int;
          description = "Number of hourly auto-snapshots to keep";
        };

        daily = lib.mkOption {
          type = lib.types.int;
          description = "Number of daily auto-snapshots to keep";
        };

        weekly = lib.mkOption {
          type = lib.types.int;
          description = "Number of weekly auto-snapshots to keep";
        };

        monthly = lib.mkOption {
          type = lib.types.int;
          description = "Number of monthly auto-snapshots to keep";
        };
      };

      zed = {
        settings = lib.mkOption {
          type =
            let
              t = lib.types;
            in
            t.attrsOf (
              t.oneOf [
                t.str
                t.int
                t.bool
                (t.listOf t.str)
              ]
            );
          description = "Settings for ZFS Event Daemon (ZED).";
        };

        enableMail = lib.mkOption {
          type = lib.types.bool;
          default = config.services.mail.sendmailSetuidWrapper != null;
          description = "Enable sending email notifications for ZFS events via ZED.";
        };
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.settings.zfs.hostId == null || config.settings.zfs.hostId != "";
        message = "Please set a valid host ID for ZFS pools. You can get it by running `head -c 8 /etc/machine-id`.";
      }
    ];

    networking.hostId = config.settings.zfs.hostId;

    boot.zfs = {
      enabled = true;
      allowHibernation = config.settings.zfs.allowHibernation;
      extraPools = config.settings.zfs.pools;
    };

    services.zfs = {
      trim = {
        enable = config.settings.zfs.autoTrim.enable;
        interval = config.settings.zfs.autoTrim.interval;
        randomizedDelaySec = config.settings.zfs.autoTrim.randomizedDelaySec;
      };

      autoScrub = {
        enable = config.settings.zfs.autoScrub.enable;
        pools = config.settings.zfs.autoScrub.pools;
        interval = config.settings.zfs.autoScrub.interval;
        randomizedDelaySec = config.settings.zfs.autoScrub.randomizedDelaySec;
      };

      autoSnapshot = {
        enable = config.settings.zfs.autoSnapshot.enable;
        flags = config.settings.zfs.autoSnapshot.flags;
        frequent = config.settings.zfs.autoSnapshot.frequent;
        hourly = config.settings.zfs.autoSnapshot.hourly;
        daily = config.settings.zfs.autoSnapshot.daily;
        weekly = config.settings.zfs.autoSnapshot.weekly;
        monthly = config.settings.zfs.autoSnapshot.monthly;
      };

      zed = {
        settings = config.settings.zfs.zed.settings;
        enableMail = config.settings.zfs.zed.enableMail;
      };
    };
  };
}
