{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    android-studio
    android-studio-tools
  ];
  nixpkgs.config.android_sdk.accept_license = true;
}
