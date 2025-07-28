{ config, pkgs, ... }:

{
  imports = [
    #../../programs/bambu-studio.nix # TODO: Enable again when fixed
    ../../programs/kitty.nix
    ../../programs/libnotify.nix
    ../../programs/librewolf.nix
    ../../programs/linux-wifi-hotspot.nix
    ../../programs/lshw-gui.nix
    ../../programs/nvtop.nix
    ../../programs/podman-desktop.nix
    ../../programs/qrtool.nix
    ../../programs/ryzen-monitor-ng.nix
    ../../programs/soco-cli.nix
    ../../programs/tor-browser.nix
    ../../programs/ungoogled-chromium.nix
    ../../programs/uni-sync.nix
    ../../programs/wallpaper-engine-kde-plugin.nix
    ../../programs/wootility.nix
  ];
}
