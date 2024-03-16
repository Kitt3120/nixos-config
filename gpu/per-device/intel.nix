{ config, pkgs, ... }:

{
  hardware.opengl = {
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      inteltool
    ];
    
    extraPackages32 = with pkgs; [
      intel-compute-runtime
      intel-media-driver
    ];
  };
}