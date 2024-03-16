{ config, pkgs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      options = "--delete-older-than-30d";
    };

    settings.auto-optimise-store = true;
  };
}