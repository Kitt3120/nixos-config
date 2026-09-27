{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = [ pkgs.openrgb-with-all-plugins ];
  services.udev.packages = [ pkgs.openrgb-with-all-plugins ];

  boot.kernelModules = [
    "i2c-dev"
  ]
  ++ lib.optionals (config.hardware.cpu.intel.updateMicrocode == true) [ "i2c-piix4" ]
  ++ lib.optionals (config.hardware.cpu.amd.updateMicrocode == true) [ "i2c-i801" ];
}
