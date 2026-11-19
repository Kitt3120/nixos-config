{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    socketActivation = true;
    systemWide = false;
    raopOpenFirewall = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false; # introduces global impurity via `LD_LIBRARY_PATH`.
  };
}
