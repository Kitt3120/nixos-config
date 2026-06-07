{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bitwarden-desktop ];

  # TODO: Remove
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

}
