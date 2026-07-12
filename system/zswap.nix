{ config, lib, ... }:

{
  options.settings.zswap = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "Alias for zswap.enable";
    };
  };

  config = {
    boot.zswap = {
      enable = config.settings.zswap.enable;
    };
  };
}
