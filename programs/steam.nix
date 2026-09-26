{ pkgs, ... }:

let
  steam-batch-edit-launch-options = pkgs.writeShellApplication {
    name = "steam-batch-edit-launch-options";
    runtimeInputs = with pkgs; [
      coreutils
      gnused
      procps
      fzf
    ];
    text = builtins.readFile ../assets/scripts/steam-batch-edit-launch-options.sh;
  };
in
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    extest.enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;

  environment.systemPackages = [ steam-batch-edit-launch-options ];
}
