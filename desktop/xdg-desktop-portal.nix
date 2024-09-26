{
  config,
  pkgs,
  lib,
  ...
}:

{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = lib.mkDefault "gtk";
  };
}
