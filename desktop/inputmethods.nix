{ config, pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    ibus.engines = with pkgs.ibus-engines; [
      anthy
      mozc
    ];
    fcitx5.addons = with pkgs; [
      fcitx5-anthy
      fcitx5-mozc
      kdePackages.fcitx5-qt
      kdePackages.fcitx5-configtool
    ];
  };

  # Credits @infinisil: https://github.com/infinisil/system/blob/07534666e0592d9ceb1fc157dc48baa7b1494d99/config/modules/japanese-input/default.nix
  # Would normally set GLFW_IM_MODULE to fcitx, but kitty only supports ibus, and fcitx
  # provides an ibus interface. Can't use ibus for e.g. QT_IM_MODULE though,
  # because that at least breaks mumble
  environment.variables = {
    GLFW_IM_MODULE = "ibus";
    IBUS_ENABLE_SYNC_MODE = "1";
  };
}
