{ config, pkgs, lib, ... }:

let
  stylix = builtins.fetchGit {
    url = "https://github.com/danth/stylix.git";
  };

  # load stylix from local at /home/torben/Nextcloud/Programmierung/NixOS/stylix/
  #stylix = import /home/torben/Nextcloud/Programmierung/NixOS/stylix;
in {
  imports = [ (import stylix).nixosModules.stylix ];

  stylix = {
    enable = true;
    polarity = "dark";

    image = pkgs.fetchurl {
      url = "https://www.pixelstalk.net/wp-content/uploads/2016/10/Anime-Landscape-Wallpaper-HD.jpg";
      sha256 = "12f275862b66e99973c933b4471574e8d1bb2997b6752c47be510e084c427c9a";
      #url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Cool-Anime-Wallpaper-HD-Free-Download.jpg";
      #sha256 = "5a265d5c428467ce01a091e4cc0c548dd2652d544e4747731dcb09c51a143802";
    };

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.nerdfonts;
        name = "Hack";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
