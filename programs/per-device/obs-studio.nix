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
            #obs-source-clone # TODO: Enable again when updated
            obs-scale-to-sound
            obs-rgb-levels-filter
            obs-multi-rtmp
            obs-composite-blur
            obs-command-source
            obs-backgroundremoval
        ];
    })
  ];
}