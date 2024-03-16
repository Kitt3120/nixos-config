{ config, pkgs, ... }:

{
    # Note: Disabling this module won't disable OOMD, as the default is still true. Switch below to set to false instead.
    systemd.oomd.enable = true;
    #systemd.oomd.enable = false;
}