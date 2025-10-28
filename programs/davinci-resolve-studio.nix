{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  studio-variant = true;
  mesa-good-pkg = inputs.mesa-good.legacyPackages.x86_64-linux.mesa;
  original = if studio-variant then pkgs.davinci-resolve-studio else pkgs.davinci-resolve;
  davinci = original.passthru.davinci;
  davinci-fixed = pkgs.buildFHSEnv {
    pname = davinci.pname;
    version = davinci.version;

    # original.extraPreBwrapCmds is exposed, but it does not respect our studio-variant flag, so we inline it here:
    extraPreBwrapCmds = lib.optionalString studio-variant ''
      mkdir -p ~/.local/share/DaVinciResolve/license || exit 1
      mkdir -p ~/.local/share/DaVinciResolve/Extras || exit 1
    '';

    # original.extraBwrapArgs is exposed, but it does not respect our studio-variant flag, so we inline it here:
    extraBwrapArgs = lib.optionals studio-variant [
      ''--bind "$HOME"/.local/share/DaVinciResolve/license ${davinci}/.license''
      ''--bind "$HOME"/.local/share/DaVinciResolve/Extras ${davinci}/Extras''
    ];

    runScript = "${pkgs.bash}/bin/bash ${pkgs.writeText "davinci-wrapper-goodmesa" ''
      export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
      export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"

      export LD_LIBRARY_PATH=${mesa-good-pkg}/lib:${mesa-good-pkg}/lib/dri:$LD_LIBRARY_PATH
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs

      exec ${davinci}/bin/resolve
    ''}";

    # we inline extraInstallCommands instead of referencing orig.extraInstallCommands, as it is not exposed
    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
      ln -s ${davinci}/share/applications/*.desktop $out/share/applications/
      ln -s ${davinci}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve${lib.optionalString studio-variant "-studio"}.png
    '';

    # we inline targetPkgs instead of referencing orig.targetPkgs, as it is not exposed
    targetPkgs = pkgs: [
      # our addition:
      mesa-good-pkg

      # original dependencies:
      pkgs.alsa-lib
      pkgs.aprutil
      pkgs.bzip2
      davinci
      pkgs.dbus
      pkgs.expat
      pkgs.fontconfig
      pkgs.freetype
      pkgs.glib
      pkgs.libGL
      pkgs.libGLU
      pkgs.libarchive
      pkgs.libcap
      pkgs.librsvg
      pkgs.libtool
      pkgs.libuuid
      pkgs.libxcrypt
      pkgs.libxkbcommon
      pkgs.nspr
      pkgs.ocl-icd
      pkgs.opencl-headers
      pkgs.python3
      pkgs.python3.pkgs.numpy
      pkgs.udev
      pkgs.xdg-utils
      pkgs.xorg.libICE
      pkgs.xorg.libSM
      pkgs.xorg.libX11
      pkgs.xorg.libXcomposite
      pkgs.xorg.libXcursor
      pkgs.xorg.libXdamage
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXi
      pkgs.xorg.libXinerama
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXt
      pkgs.xorg.libXtst
      pkgs.xorg.libXxf86vm
      pkgs.xorg.libxcb
      pkgs.xorg.xcbutil
      pkgs.xorg.xcbutilimage
      pkgs.xorg.xcbutilkeysyms
      pkgs.xorg.xcbutilrenderutil
      pkgs.xorg.xcbutilwm
      pkgs.xorg.xkeyboardconfig
      pkgs.zlib
    ];

    passthru = original.passthru;
    meta = original.meta;
  };
in
{
  environment.systemPackages = with pkgs; [ davinci-fixed ];
}
