{ config, pkgs, ... }:

{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
