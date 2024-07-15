{ config, pkgs, ... }:

{
  hardware.graphics = {
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
      radeontop
      radeontools
      radeon-profile
    ];
    
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  environment.sessionVariables.AMDVLK_ENABLE_DEVELOPING_EXT = "all";
  services.xserver.videoDrivers = [ "amdgpu" ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}