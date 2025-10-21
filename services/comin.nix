{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.comin.nixosModules.comin ];

  options.settings.comin = {
    remotes = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule (
          { ... }:
          {
            options = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "URL of the remote Git repository to sync with.";
              };

              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the remote to track.";
              };

              branch = lib.mkOption {
                type = lib.types.str;
                description = "Name of the branch to track.";
              };

              poll-interval = lib.mkOption {
                type = lib.types.int;
                description = "Interval (seconds) between polling this remote for changes.";
              };
            };
          }
        )
      );
      description = "List of comin remotes to track.";
    };
  };

  config = {
    services.comin = {
      enable = true;
      remotes = builtins.map (remote: {
        url = remote.url;
        name = remote.name;
        branches.main.name = remote.branch;
        poller.period = remote.poll-interval;
      }) config.settings.comin.remotes;
    };
  };
}
