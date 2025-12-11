{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = [
      pkgs.obs-studio-plugins.pixel-art
      pkgs.obs-studio-plugins.waveform
      pkgs.obs-studio-plugins.input-overlay
      #pkgs.obs-studio-plugins.droidcam-obs # TODO: Enable again when fixed
      pkgs.obs-studio-plugins.obs-websocket
      pkgs.obs-studio-plugins.obs-vkcapture
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      pkgs.obs-studio-plugins.obs-gstreamer
      pkgs.obs-studio-plugins.obs-vaapi
      pkgs.obs-studio-plugins.obs-source-clone
      pkgs.obs-studio-plugins.obs-scale-to-sound
      pkgs.obs-studio-plugins.obs-composite-blur
      pkgs.obs-studio-plugins.obs-command-source
      pkgs.obs-studio-plugins.obs-backgroundremoval

    ];
  };

  # Allow obs-websocket port through firewall
  networking.firewall.allowedTCPPorts = [ 4455 ];
}
