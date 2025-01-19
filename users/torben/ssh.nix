{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.credentials.user.torben.ssh = {
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };

    blocks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  config = {
    users.users.torben.openssh.authorizedKeys.keys = config.credentials.user.torben.ssh.authorizedKeys;
    home-manager.users.torben.home.file.".ssh/config".text =
      lib.strings.concatStrings config.credentials.user.torben.ssh.blocks;
  };
}
