{ config, pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
  };
}
