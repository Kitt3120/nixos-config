{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.credentials.user.minecraft.ssh.authorizedKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };

  config.users.users.minecraft.openssh.authorizedKeys.keys =
    config.credentials.user.minecraft.ssh.authorizedKeys;
}
