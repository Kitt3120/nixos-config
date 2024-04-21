{ config, pkgs, lib, ... }:

{
  users.users.torben.openssh.authorizedKeys.keys = config.credentials.authorizedKeys;

  home-manager.users.torben.home.file.".ssh/config".text = lib.strings.concatStrings [
    config.ssh.blocks.mrmeeseeks
    config.ssh.blocks.schweren-dev
  ];
}