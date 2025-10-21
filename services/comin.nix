{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.comin.nixosModules.comin ];

  options.settings.comin = {

    url = lib.mkOption {
      type = lib.types.str;
      description = "URL of the remote Git repository to sync with.";
    };

    remote = lib.mkOption {
      type = lib.types.str;
      description = "Name of the remote to track.";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      description = "Name of the branch to track.";
    };

    poll-interval = lib.mkOption {
      type = lib.types.int;
      description = "Interval in seconds between polling remote repositories for changes.";
    };
  };

  config = {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = config.settings.comin.remote;
          url = config.settings.comin.url;
          branches.main.name = config.settings.comin.branch;
          poller.period = config.settings.comin.poll-interval;
        }
      ];
    };
  };
}
