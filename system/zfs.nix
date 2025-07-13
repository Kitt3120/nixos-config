{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.settings = {
    zfs = {
      hostId = lib.mkOption {
        type = lib.types.str;
        description = "Host ID used for ZFS pools.";
      };

      pools = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of ZFS pools to manage.";
      };

      devNodes = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Relative path to find ZFS devices when importing at boot. Usually, /dev/disk/by-id is fine, but for example on some VM hypervisors, you might need to set this to e.g. /dev.";
      };

      vdevIds = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Map nicknames to vdev IDs for ZFS pools.";
      };

      forceImportRoot = lib.mkOption {
        type = lib.types.bool;
        default = false; # NixOS has default set to true, which is a mistake in my opinion
        description = "Force import of the root ZFS pool. Use with caution, especially with allowHibernation=true. If NixOS subsequently fails to boot because it cannot import the root pool, you should boot with the `zfs_force=1` kernel parameter.";
      };

      allowHibernation = lib.mkOption {
        type = lib.types.nullOr lib.types.bool;
        default = null;
        description = "Allow ZFS to hibernate the system. Only enable if you have a swap partition outside of ZFS.";
      };

      autoTrim = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Enable automatic invocation of zpool trim command";
        };

        interval = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Interval for automatic ZFS trimming. Systemd format is used for scheduling (e.g., daily, weekly, monthly).";
        };

        randomizedDelaySec = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Add a randomized delay before each ZFS trim. The delay will be chosen between zero and this value. Systemd format is used (e.g., 30s, 1m, 2h).";
        };
      };

      autoScrub = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Enable automatic scrubbing of ZFS pools";
        };

        pools = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = "List of ZFS pools to scrub automatically";
        };

        interval = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Interval for automatic scrubbing. Systemd format is used for scheduling (e.g., daily, weekly, monthly).";
        };

        randomizedDelaySec = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Add a randomized delay before each ZFS autoscrub. The delay will be chosen between zero and this value. Systemd format is used (e.g., 30s, 1m, 2h).";
        };
      };

      autoSnapshot = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Enable automatic snapshots of ZFS datasets";
        };

        flags = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Flags to pass to zfs snapshot command for automatic snapshots";
        };

        frequent = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Number of frequent (15-minute) auto-snapshots to keep";
        };

        hourly = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Number of hourly auto-snapshots to keep";
        };

        daily = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Number of daily auto-snapshots to keep";
        };

        weekly = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Number of weekly auto-snapshots to keep";
        };

        monthly = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = "Number of monthly auto-snapshots to keep";
        };
      };

      zed = {
        enableMail = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = "Enable sending email notifications for ZFS events via ZED.";
        };

        mailTo = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Email address to send ZFS event notifications to.";
        };

        extraSettings = lib.mkOption {
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
          default = { };
          description = "Extra settings for ZFS Event Daemon (ZED).";
        };
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = config.settings.zfs.zed.enableMail -> config.settings.zfs.zed.mailTo != null;
        message = "If ZED email notifications are enabled, please set a valid email address in `settings.zfs.zed.mailTo`.";
      }
    ];

    networking.hostId = config.settings.zfs.hostId;

    environment.etc."zfs/vdev_id.conf".text =
      "#     by-vdev
#     name     fully qualified or base name of device link
# run 'udevadm trigger' after updating this file through config.settings.zfs.vdevIds\n"
      + lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: id: "alias ${name}      ${id}") config.settings.zfs.vdevIds
      );

    boot.supportedFilesystems = {
      zfs = true;
    };

    boot.zfs = {
      devNodes = lib.mkIf (config.settings.zfs.devNodes != null) config.settings.zfs.devNodes;
      forceImportRoot = config.settings.zfs.forceImportRoot;
      extraPools = config.settings.zfs.pools;

      allowHibernation = lib.mkIf (
        config.settings.zfs.allowHibernation != null
      ) config.settings.zfs.allowHibernation;
    };

    services.zfs = {
      trim = {
        enable = config.settings.zfs.autoTrim.enable;

        interval = lib.mkIf (
          config.settings.zfs.autoTrim.interval != null
        ) config.settings.zfs.autoTrim.interval;

        randomizedDelaySec = lib.mkIf (
          config.settings.zfs.autoTrim.randomizedDelaySec != null
        ) config.settings.zfs.autoTrim.randomizedDelaySec;
      };

      autoScrub = {
        enable = config.settings.zfs.autoScrub.enable;

        pools =
          if config.settings.zfs.autoScrub.pools != null then
            config.settings.zfs.autoScrub.pools
          else
            config.settings.zfs.pools;

        interval = lib.mkIf (
          config.settings.zfs.autoScrub.interval != null
        ) config.settings.zfs.autoScrub.interval;

        randomizedDelaySec = lib.mkIf (
          config.settings.zfs.autoScrub.randomizedDelaySec != null
        ) config.settings.zfs.autoScrub.randomizedDelaySec;
      };

      autoSnapshot = {
        enable = config.settings.zfs.autoSnapshot.enable;

        flags = lib.mkIf (
          config.settings.zfs.autoSnapshot.flags != null
        ) config.settings.zfs.autoSnapshot.flags;

        frequent = lib.mkIf (
          config.settings.zfs.autoSnapshot.frequent != null
        ) config.settings.zfs.autoSnapshot.frequent;

        hourly = lib.mkIf (
          config.settings.zfs.autoSnapshot.hourly != null
        ) config.settings.zfs.autoSnapshot.hourly;

        daily = lib.mkIf (
          config.settings.zfs.autoSnapshot.daily != null
        ) config.settings.zfs.autoSnapshot.daily;

        weekly = lib.mkIf (
          config.settings.zfs.autoSnapshot.weekly != null
        ) config.settings.zfs.autoSnapshot.weekly;

        monthly = lib.mkIf (
          config.settings.zfs.autoSnapshot.monthly != null
        ) config.settings.zfs.autoSnapshot.monthly;
      };

      zed = {
        enableMail = lib.mkIf (
          config.settings.zfs.zed.enableMail != null
        ) config.settings.zfs.zed.enableMail;

        settings = {
          ZED_EMAIL_ADDR =
            if config.settings.zfs.zed.mailTo != null then config.settings.zfs.zed.mailTo else "";
          ZED_EMAIL_OPTS = "@ADDRESS@";
          ZED_NOTIFY_VERBOSE = 1;
          ZED_USE_ENCLOSURE_LEDS = 1;
          ZED_SYSLOG_SUBCLASS_EXCLUDE = "history_event";
        } // config.settings.zfs.zed.extraSettings;
      };
    };
  };
}
