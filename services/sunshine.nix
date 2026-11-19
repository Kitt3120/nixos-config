{ config, lib, ... }:

{
  options.settings.sunshine = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Settings for Sunshine.";
    };

    apps = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "List of apps to be added to Sunshine.";
    };
  };

  config = {
    # Disable MangoHud for the Sunshine service to fix crashes
    systemd.user.services.sunshine.environment = {
      DISABLE_MANGOHUD = "1";
    };

    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      settings = config.settings.sunshine.settings;
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = config.settings.sunshine.apps;
      };
    };
  };
}
