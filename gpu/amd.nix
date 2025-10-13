{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.settings = {
    amd.overdrive = {
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
    hardware = {
      amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        overdrive = {
          enable = config.settings.amd.overdrive.enable;
          ppfeaturemask = config.settings.amd.overdrive.ppfeaturemask;
        };
      };
    };

    # Useful userland tools for AMD GPUs
    environment.systemPackages = with pkgs; [
      radeontop
      rocmPackages.rocm-smi
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
          ];
        };
      in
      [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];
  };
}
