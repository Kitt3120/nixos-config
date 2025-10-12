{ config, pkgs, ... }:

{
  imports = [
    ../programs/an-anime-team-launchers.nix
    ../programs/dolphin-emulator.nix
    ../programs/gamemode.nix
    ../programs/gamescope.nix
    ../programs/lutris.nix
    ../programs/mangohud.nix
    ../programs/moonlight-qt.nix
    ../programs/osu-lazer.nix
    ../programs/prism-launcher.nix
    ../programs/protonup.nix
    #../programs/retroarch.nix # TODO: Enable again when fixed upstream
    ../programs/steam.nix
    ../programs/vintage-story.nix
  ];
}
