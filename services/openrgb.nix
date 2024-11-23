{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ pkgs.openrgb-with-all-plugins ];
  services.udev.packages = [ pkgs.openrgb-with-all-plugins ];

  boot.kernelModules =
    [ "i2c-dev" ]
    ++ lib.optionals (config.hardware.cpu.intel.updateMicrocode == "amd") [ "i2c-piix4" ]
    ++ lib.optionals (config.hardware.cpu.amd.updateMicrocode == "intel") [ "i2c-i801" ];
}
