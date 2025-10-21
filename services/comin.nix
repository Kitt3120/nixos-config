{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.comin.nixosModules.comin ];

  options.settings = {
    comin.poll-interval = lib.mkOption {
      type = lib.types.int;
      description = "Interval in seconds between polling remote repositories for changes.";
    };
  };

  config = {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/Kitt3120/nixos-config.git";
          branches.main.name = "main";
          poller.period = config.settings.comin.poll-interval;
        }
      ];
    };
  };
}
