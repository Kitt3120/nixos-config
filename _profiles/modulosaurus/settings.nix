{ ... }:

{
  settings = {
    sops.device-secrets = ../../secrets/modulosaurus.yaml;

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

    amd.overdrive = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };

    sunshine = {
      settings = {
        output_name = 1;
      };

      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
          auto-detach = "true";
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          prep-cmd = [
            {
              do = "sudo -u torben setsid steam steam://open/bigpicture";
              undo = "sudo -u torben setsid steam steam://close/bigpicture";
            }
          ];
          auto-detach = "true";
        }
      ];
    };
  };
}
