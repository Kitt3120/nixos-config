{ config, pkgs, ... }:

{
  imports = [
    ../../programs/per-device/gparted.nix
    ../../programs/per-device/firefox.nix
    ../../programs/per-device/vscode.nix
    ../../programs/per-device/vscode-insiders.nix
    ../../programs/per-device/obs-studio.nix
    ../../programs/per-device/wine-staging.nix
    ../../programs/per-device/gamescope.nix
    ../../programs/per-device/steam.nix
    ../../programs/per-device/mangohud.nix
    ../../programs/per-device/handbrake.nix
    ../../programs/per-device/osu-lazer.nix
  ];
}