{ config, pkgs, ... }:

{
  # TODO: Disabled for now as it causes problems with some programs, like VSCode
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    egl-wayland
    eglexternalplatform
  ];
}
