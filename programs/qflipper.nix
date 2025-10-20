{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qFlipper ];
  services.udev.packages = with pkgs; [ qFlipper ];
}
