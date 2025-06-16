{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    settings.amd.overdrive = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Enable AMD GPU overdrive features.";
      };

      ppfeaturemask = lib.mkOption {
        type = lib.types.str;
        description = "AMD GPU overdrive feature mask. Default is 0xffffffff (all features enabled).";
      };
    };
  };

  config = {
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk.enable = false; # We want to use Mesa's RADV Vulkan driver
      overdrive = {
        enable = config.settings.amd.overdrive.enable;
        ppfeaturemask = config.settings.amd.overdrive.ppfeaturemask;
      };
    };

    # Additional ROCm packages not covered by hardware.amdgpu.opencl.enable
    hardware.graphics = {
      extraPackages = with pkgs; [
        rocmPackages.hipblas
        rocmPackages.rocblas
      ];
    };

    # Useful userland tools for AMD GPUs
    environment.systemPackages = with pkgs; [
      radeontop
      radeontools
      radeon-profile
    ];

    # Fix some ROCm related issues specific to NixOS
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
  };
}
