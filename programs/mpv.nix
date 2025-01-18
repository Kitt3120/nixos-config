{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ mpv-unwrapped ];

  environment.etc."mpv/mpv.conf".text = ''
    sub-auto=fuzzy
    profile=high-quality
    video-sync=display-resample
    interpolation
    hwdec=auto
  '';
}
