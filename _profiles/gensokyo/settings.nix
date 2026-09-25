{ ... }:

{
  settings = {
    sops.device-secrets = ../../secrets/gensokyo.yaml;

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
    
    networking.wireguard.publicKey = "M2fupWZjNrQUDAcQoB1Lq9Tof+USBJm0Stgw9T+yJjM=";

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
