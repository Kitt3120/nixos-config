{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (wrapOBS {
        plugins = with obs-studio-plugins; [
            waveform
            input-overlay
            droidcam-obs
            obs-websocket
            obs-webkitgtk
            obs-vkcapture
            obs-pipewire-audio-capture
            obs-gstreamer
            obs-vaapi
            obs-source-clone
            obs-scale-to-sound
            obs-rgb-levels-filter
            obs-composite-blur
            obs-command-source
            obs-backgroundremoval
        ];
    })
  ];
}