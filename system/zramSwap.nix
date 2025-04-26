{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    settings.zramSwap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Alias for zramSwap.enable.";
      };

      priority = lib.mkOption {
        type = lib.types.int;
        description = "Alias for zramSwap.priority.";
      };

      memoryPercent = lib.mkOption {
        type = lib.types.int;
        description = "Alias for zramSwap.memoryPercent.";
      };

      algorithm = lib.mkOption {
        type = lib.types.str;
        description = "Alias for zramSwap.algorithm.";
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
  };
}
