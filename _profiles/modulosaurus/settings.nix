{
  config,
  pkgs,
  lib,
  ...
}:

{
  settings = {
    sops.device-secrets = ../../secrets/modulosaurus.yaml;

    memoryAllocator = "libc";

    zramSwap = {
      enable = true;
      optimiseSysctl = true;
      algorithm = "zstd";
      priority = 5;
      memoryPercent = 50;
    };

    amd.overdrive = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };
}
