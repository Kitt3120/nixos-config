{ config, pkgs, lib, ... }:

{
  users.users.torben.openssh.authorizedKeys.keys = config.credentials.user.torben.ssh.authorizedKeys;
  home-manager.users.torben.home.file.".ssh/config".text = lib.strings.concatStrings config.credentials.user.torben.ssh.blocks;
}