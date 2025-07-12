{ config, pkgs, ... }:

{
  imports = [
    ../../programs/framework-tool.nix
    ../../programs/kitty.nix
    ../../programs/libnotify.nix
    ../../programs/librewolf.nix
    ../../programs/linux-wifi-hotspot.nix
    ../../programs/lshw-gui.nix
    ../../programs/nvtop.nix
    ../../programs/qrtool.nix
    ../../programs/ryzen-monitor-ng.nix
    ../../programs/soco-cli.nix
    ../../programs/syncplay.nix
    ../../programs/tor-browser.nix
    ../../programs/ungoogled-chromium.nix
    ../../programs/wallpaper-engine-kde-plugin.nix
    ../../programs/wootility.nix
  ];
}
