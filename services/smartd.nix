{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.smartd = {
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
    defaults.monitored = "-a -o on -s (S/../.././02|L/../../7/04) -W ${toString config.smartd.temperatureChangeThreshold},${toString config.smartd.temperatureLog},${toString config.smartd.temperatureMax}";
    notifications.wall.enable = true;
    notifications.mail = {
      enable = true;
      recipient = config.credentials.mail.user;
      sender = config.credentials.mail.from;
    };
  };
}
