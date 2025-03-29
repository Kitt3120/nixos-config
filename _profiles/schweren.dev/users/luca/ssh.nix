{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.credentials.user.luca.ssh.authorizedKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config.users.users.luca.openssh.authorizedKeys.keys =
    config.credentials.user.luca.ssh.authorizedKeys;
}
