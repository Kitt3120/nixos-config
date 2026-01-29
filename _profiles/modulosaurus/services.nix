{ ... }:

{
  imports = [
    ../../services/flatpak.nix
    ../../services/logitech.nix
    ../../services/media-pipelines-ffmpeg.nix
    ../../services/mullvad.nix
    #../../services/opendeck.nix # TODO: Enable again
    ../../services/openrgb.nix
    ../../services/opentabletdriver.nix
    ../../services/ratbagd.nix
    ../../services/smartd.nix
    ../../services/sunshine.nix
  ];
}
