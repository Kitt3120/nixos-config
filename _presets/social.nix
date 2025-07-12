{ config, pkgs, ... }:

{
  imports = [
    ../programs/signal.nix
    ../programs/teams-for-linux.nix
    ../programs/vesktop.nix
  ];
}
