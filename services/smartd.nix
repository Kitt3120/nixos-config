{ config, lib, ... }:

{
  options.settings.smartd = {
    temperatureChangeThreshold = lib.mkOption {
      default = 4;
      type = lib.types.int;
    };

    temperatureLog = lib.mkOption {
      default = 70;
      type = lib.types.int;
    };

    temperatureMax = lib.mkOption {
      default = 70;
      type = lib.types.int;
    };
  };

  config.services.smartd = {
    enable = true;
    autodetect = true;
    defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04) -W ${toString config.settings.smartd.temperatureChangeThreshold},${toString config.settings.smartd.temperatureLog},${toString config.settings.smartd.temperatureMax}";
    notifications.wall.enable = true;
    notifications.mail = {
      enable = true;
      recipient = "\$(cat ${config.sops.secrets."mail/user".path})";
      sender = "\$(cat ${config.sops.secrets."mail/from".path})";
    };
  };
}
