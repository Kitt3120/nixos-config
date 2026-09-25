{ ... }:

{
  settings = {
    sops.device-secrets = ../../secrets/gensokyo.yaml;

    networking.wireguard.interfaces.MrMeeseeks.peers.MrMeeseeks = { };

    comin = {
      autoReboot = false;
      remotes = [
        {
          url = "https://github.com/Kitt3120/nixos-config.git";
          name = "origin";
          branch = "main";
          pollInterval = 60;
        }
      ];
    };

    memoryAllocator = "libc";

    zramSwap = {
      enable = true;
      optimiseSysctl = true;
      algorithm = "zstd";
      priority = 5;
      memoryPercent = 50;
    };

    podman.dockerMode = true;
  };
}
