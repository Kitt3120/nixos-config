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
      sha256 = "sha256-6V+yvf8DLcYtpgRNuXoSGo5rC+XE8lG2vnCe5jMF5vA=";
    };

    postPatch = ''
      patchShebangs scripts/build-udev-rules.sh
      substituteInPlace scripts/build-udev-rules.sh \
        --replace /bin/chmod "${pkgs.coreutils}/bin/chmod"
      substituteInPlace scripts/build-udev-rules.sh \
        --replace /usr/bin/env "${pkgs.coreutils}/bin/env"
    '';
  });
in
{
  environment.systemPackages = [ openrgb-master ];
  services.udev.packages = [ openrgb-master ];

  boot.kernelModules =
    [ "i2c-dev" ]
    ++ lib.optionals (config.hardware.cpu.intel.updateMicrocode == "amd") [ "i2c-piix4" ]
    ++ lib.optionals (config.hardware.cpu.amd.updateMicrocode == "intel") [ "i2c-i801" ];
}
