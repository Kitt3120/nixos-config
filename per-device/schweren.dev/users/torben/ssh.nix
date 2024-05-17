{ config, pkgs, lib, ... }:

{
  users.users.torben.openssh.authorizedKeys.keys = config.credentials.user.torben.ssh.authorizedKeys;
}