{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vesktop ];

  # TODO: Remove
  nixpkgs.config.permittedInsecurePackages = [
    "electron-40.10.5"
  ];

}
