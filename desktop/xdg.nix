{
  config,
  pkgs,
  lib,
  ...
}:

{
  xdg = {
    autostart.enable = true;
    sounds.enable = true;
    mime.enable = true;
    menus.enable = true;
    icons.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = lib.mkDefault "gtk";
    };
  };
}
