{ config, pkgs, ... }:

{
  services.logrotate = {
    enable = true;
    settings = {
        header = {
            frequency = "weekly";
            rotate = 4;
            create = true;
        };
    };
  };
}