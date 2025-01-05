{ config, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    extraPackages = with pkgs; [
      rocmPackages.hipblas
      rocmPackages.rocblas
      rocmPackages.clr
      rocmPackages.clr.icd
      radeontop
      radeontools
      radeon-profile
    ];
  };

  systemd.tmpfiles.rules =
    let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
          clr.icd
        ];
      };
    in
    [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
}
