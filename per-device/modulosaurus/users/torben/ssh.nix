{ config, pkgs, ... }:

{
    users.users.torben.openssh.authorizedKeys.keys = config.credentials.authorizedKeys;
}