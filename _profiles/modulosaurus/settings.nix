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

    podman.dockerMode = true;

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
        {
          name = "Retroarch";
          image-path = builtins.fetchurl {
            url = "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.steamgriddb.com%2Fgrid%2F8fb49549f3fd57ad0a80e57825f9e41e.png&f=1&nofb=1&ipt=20215f50499b0ae3bcce7872bc85b13ec7584a6fc8963c02df4ceb5b2b1370ff";
            name = "retroarch.png";
            sha256 = "sha256:09qkfflbqbxc5ndwbsa7s102pmg7lyqvrc25g1crkp58jn2idsdv";
          };
          cmd = "sudo -u torben setsid retroarch";
        }
      ];
    };
  };
}
