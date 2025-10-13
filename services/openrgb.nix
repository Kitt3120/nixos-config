{
  config,
  pkgs,
  lib,
  ...
}:

# TODO: Remove overrideAttrs workaround and commit the fix to nixpkgs
let
  openrgb-master = pkgs.openrgb-with-all-plugins.overrideAttrs (oldAttrs: rec {

    version = "master";

    src = pkgs.fetchFromGitLab {
      owner = "CalcProgrammer1";
      repo = "OpenRGB";
      rev = "master";
      sha256 = "sha256-8x3gQdV8A0h4+6Sp+CrmICQnzY2pVSFe/sxnFPKEG8g=";
    };

    patches = [ ]; # removes upstreams qlist-include.patch, which is not needed anymore

    postPatch = ''
      # Fix shebangs in scripts
      patchShebangs scripts/build-udev-rules.sh
      substituteInPlace scripts/build-udev-rules.sh \
        --replace-fail /usr/bin/env "${pkgs.coreutils}/bin/env"

      # Remove installing OpenRGB's systemd service from the qmake file
      substituteInPlace ./OpenRGB.pro \
        --replace-fail "INSTALLS += target desktop icon metainfo udev_rules systemd_service" "INSTALLS += target desktop icon metainfo udev_rules"
    '';
  });
in
{
  environment.systemPackages = [ openrgb-master ];
  services.udev.packages = [ openrgb-master ];

  boot.kernelModules = [
    "i2c-dev"
  ]
  ++ lib.optionals (config.hardware.cpu.intel.updateMicrocode == true) [ "i2c-piix4" ]
  ++ lib.optionals (config.hardware.cpu.amd.updateMicrocode == true) [ "i2c-i801" ];
}
