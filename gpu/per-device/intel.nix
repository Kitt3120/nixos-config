{ config, pkgs, ... }:

{
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
      inteltool
    ];

    extraPackages32 = with pkgs; [
      driversi686Linux.intel-media-driver
      driversi686Linux.intel-vaapi-driver
    ];
  };
}
