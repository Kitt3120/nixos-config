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
        #audio_sink = "alsa_output.usb-Generic_USB_Audio-00.HiFi__Speaker__sink";
      };

      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          detached = [
            "sudo -u torben setsid steam steam://open/bigpicture"
          ];
          prep-cmd = [
            {
              do = "";
              undo = "sudo -u torben setsid steam steam://close/bigpicture";
            }
          ];
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
      ];
    };
  };
}
