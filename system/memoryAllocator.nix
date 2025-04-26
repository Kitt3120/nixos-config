{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.settings.memoryAllocator = lib.mkOption {
    type = lib.types.str;
    description = "Alias for environment.memoryAllocator.provider.";
  };

  config = {
    environment.memoryAllocator.provider = config.settings.memoryAllocator;
  };
}
