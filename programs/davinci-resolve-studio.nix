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

  davinci-resolve-fix-audio = pkgs.writeShellScriptBin "davinci-resolve-fix-audio" ''
    # Check if at least 1 argument is provided
    if [ "$#" -lt 1 ]; then
      echo "Usage: davinci-resolve-fix-audio <file/directory> [directory]"
      exit 1
    fi

    # Dependencies
    FFMPEG=${pkgs.ffmpeg}/bin/ffmpeg
    PWD=${pkgs.coreutils}/bin/pwd
    DIRNAME=${pkgs.coreutils}/bin/dirname
    BASENAME=${pkgs.coreutils}/bin/basename
    REALPATH=${pkgs.coreutils}/bin/realpath
    FIND=${pkgs.findutils}/bin/find

    # Variables
    FFMPEG_AUDIO_CODEC="flac"
    FFMPEG_VIDEO_CODEC="copy"
    FFMPEG_VIDEO_CONTAINER="mp4"
    FILE_EXTENSION="mp4"
    FIND_EXTENSIONS=("mov" "mp4" "mkv" "avi")

    SOURCE_PATH="$($REALPATH "$1")"
    if [ ! -e "$SOURCE_PATH" ]; then
      echo "Error: Source path '$SOURCE_PATH' does not exist."
      exit 1
    fi

    IS_SOURCE_PATH_DIR=false
    if [ -d "$SOURCE_PATH" ]; then
      IS_SOURCE_PATH_DIR=true
    fi

    if [ "$IS_SOURCE_PATH_DIR" = true ] && [[ "$SOURCE_PATH" != */ ]]; then
      SOURCE_PATH="$SOURCE_PATH/"
    fi

    TARGET_DIR="$SOURCE_PATH"
    if [ "$IS_SOURCE_PATH_DIR" = false ]; then
      TARGET_DIR="$($DIRNAME "$SOURCE_PATH")"
    fi
    if [ "$#" -ge 2 ]; then
      TARGET_DIR="$($REALPATH "$2")"
    fi
    if [[ "$TARGET_DIR" != */ ]]; then
      TARGET_DIR="$TARGET_DIR/"
    fi
    if [ ! -d "$TARGET_DIR" ]; then
      echo "Error: Target directory '$TARGET_DIR' does not exist."
      exit 1
    fi
    if [ -f "$TARGET_DIR" ]; then
      echo "Error: Target path '$TARGET_DIR' is a file, not a directory."
      exit 1
    fi

    # Functions
    function process_file {
      local file_path="$($REALPATH "$1")"

      local file_name_without_ext="$($BASENAME "$file_path")"
      file_name_without_ext="''${file_name_without_ext%.*}"
      local target_file_path="''${TARGET_DIR}''${file_name_without_ext}.''${FILE_EXTENSION}"
      if [ -e "$target_file_path" ]; then
        target_file_path="''${TARGET_DIR}''${file_name_without_ext}_fixed.''${FILE_EXTENSION}"
      fi

      echo -n "Processing file: $file_path -> $target_file_path "
      ''${FFMPEG} -i "$file_path" -c:v "''${FFMPEG_VIDEO_CODEC}" -c:a "''${FFMPEG_AUDIO_CODEC}" "$target_file_path" -hide_banner -loglevel error -n
      local result=$?
      if [ $result -ne 0 ]; then
        echo "''\r✘ Failed to process file: $file_path"
      else
        echo "''\r✔ Processed file: $file_path -> $target_file_path"
      fi
    }

    function process_directory {
      local dir_path="$($REALPATH "$1")"

      local find_command=("$FIND" "$dir_path" -type f \( )
      local first=true
      for ext in "''${FIND_EXTENSIONS[@]}"; do
        if [ "$first" = true ]; then
          first=false
        else
          find_command+=(-o)
        fi
        find_command+=(-iname "*.$ext")
      done
      find_command+=(\) )

      # First collect files, then process them to avoid issues because of the \r used in process_file
      local files=()
      while IFS= read -r -d "" file; do
        files+=("$file")
      done < <("''${find_command[@]}" -print0)

      for file in "''${files[@]}"; do
        process_file "$file"
      done
    }

    echo "Video codec: $FFMPEG_VIDEO_CODEC, Audio codec: $FFMPEG_AUDIO_CODEC, Container: $FFMPEG_VIDEO_CONTAINER"
    if [ "$IS_SOURCE_PATH_DIR" = true ]; then
      process_directory "$SOURCE_PATH"
    else
      process_file "$SOURCE_PATH"
    fi
  '';
in
{
  environment.systemPackages = with pkgs; [
    davinci-fixed
    davinci-resolve-fix-audio
  ];
}
