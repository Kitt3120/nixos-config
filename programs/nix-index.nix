{ config, pkgs, ... }:

{
  programs.nix-index = {
    enable = true;

    # They are conflicting with command-not-found
    enableBashIntegration = false;
    enableZshIntegration = false;
  };
}
