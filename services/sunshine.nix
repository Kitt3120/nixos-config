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
