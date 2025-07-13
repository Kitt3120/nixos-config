{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.settings = {
    zramSwap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Alias for zramSwap.enable";
      };

      optimiseSysctl = lib.mkOption {
        type = lib.types.bool;
        description = "Applies sysctl settings to optimize zram swap usage. Reference: https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram";
      };

      priority = lib.mkOption {
        type = lib.types.int;
        description = "Alias for zramSwap.priority";
      };

      memoryPercent = lib.mkOption {
        type = lib.types.int;
        description = "Alias for zramSwap.memoryPercent";
      };

      algorithm = lib.mkOption {
        type = lib.types.str;
        description = "Alias for zramSwap.algorithm";
      };
    };
  };

  config = {
    zramSwap = {
      enable = config.settings.zramSwap.enable;
      priority = config.settings.zramSwap.priority;
      memoryPercent = config.settings.zramSwap.memoryPercent;
      algorithm = config.settings.zramSwap.algorithm;
    };

    # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    boot.kernel.sysctl = lib.mkIf config.settings.zramSwap.optimiseSysctl {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };
  };
}
