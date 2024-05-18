{ config, pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    egl-wayland
    eglexternalplatform
  ];
}
