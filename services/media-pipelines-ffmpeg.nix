{ config, pkgs, ... }:

let
  media-pipelines-ffmpeg = pkgs.writeShellScriptBin "media-pipelines-ffmpeg" ''
    # Dependencies
    FFMPEG=${pkgs.ffmpeg}/bin/ffmpeg
    JQ=${pkgs.jq}/bin/jq
    LS=${pkgs.coreutils}/bin/ls
    FIND=${pkgs.findutils}/bin/find
    BASENAME=${pkgs.coreutils}/bin/basename
    RIPGREP=${pkgs.ripgrep}/bin/rg

    # Variables
    IFS_DEFAULT=$IFS

    # Paths
    PIPELINES_DIR="/home/$(whoami)/Pipelines"
    PIPELINES_FFMPEG_DIR="$PIPELINES_DIR/FFmpeg"
    PROFILES_FILE="$PIPELINES_FFMPEG_DIR/profiles.json"

    # Create FFmpeg pipelines directory if it doesn't exist
    if [ ! -d "$PIPELINES_FFMPEG_DIR" ]; then
      echo "FFmpeg pipelines directory not found, creating it..."
      mkdir -p "$PIPELINES_FFMPEG_DIR"
    fi

    # Create profiles file if it doesn't exist
    if [ ! -f "$PROFILES_FILE" ]; then
      echo "FFmpeg profiles file not found, creating it..."
      echo '[]' > "$PROFILES_FILE"
    fi

    # Read profiles file
    PROFILES_FILE_CONTENT=$(cat "$PROFILES_FILE")
    PROFILES=$(echo "$PROFILES_FILE_CONTENT" | $JQ -r '.[]')

    # Read profiles from directory and from disk
    PROFILE_NAMES=$(echo "$PROFILES" | $JQ -r '.name')
    PROFILE_DIRS=$($FIND "$PIPELINES_FFMPEG_DIR" -mindepth 1 -maxdepth 1 -type d -exec $BASENAME {} \;)

    # Remove directories that no longer have profiles
    IFS=$'\n'
    for PROFILE_NAME in $PROFILE_DIRS; do
      IFS=$IFS_DEFAULT

      PROFILE_DIR="$PIPELINES_FFMPEG_DIR/$PROFILE_NAME"
      if ! echo "$PROFILE_NAMES" | grep -Fxq "$PROFILE_NAME"; then
        echo "Profile $PROFILE_NAME no longer exists, removing its directory..."
        rm -rf "$PROFILE_DIR"
      fi

      IFS=$'\n'
    done
    IFS=$IFS_DEFAULT

    # Handle profiles
    IFS=$'\n'
    for PROFILE_NAME in $PROFILE_NAMES; do
      IFS=$IFS_DEFAULT

      # Per-profile variables
      PROFILE_DIR="$PIPELINES_FFMPEG_DIR/$PROFILE_NAME"
      OUT_DIR="$PROFILE_DIR/Output"
      SUCCESS_DIR="$PROFILE_DIR/Successful"
      FAILED_DIR="$PROFILE_DIR/Failed"

      # Create profile directories if they don't exist
      if [ ! -d "$PROFILE_DIR" ]; then
        echo "Directory for profile $PROFILE_NAME not found, creating it..."
        mkdir -p "$PROFILE_DIR"
      fi

      # Create out directories if they don't exist
      if [ ! -d "$OUT_DIR" ]; then
        echo "Output directory for profile $PROFILE_NAME not found, creating it..."
        mkdir -p "$OUT_DIR"
      fi

      # Create success directories if they don't exist
      if [ ! -d "$SUCCESS_DIR" ]; then
        echo "Successful directory for profile $PROFILE_NAME not found, creating it..."
        mkdir -p "$SUCCESS_DIR"
      fi

      # Create failed directories if they don't exist
      if [ ! -d "$FAILED_DIR" ]; then
        echo "Failed directory for profile $PROFILE_NAME not found, creating it..."
        mkdir -p "$FAILED_DIR"
      fi

      # Parse profile
      PROFILE=$(echo "$PROFILES" | $JQ -r "select(.name == \"$PROFILE_NAME\")")
      PROFILE_VIDEO=$(echo "$PROFILE" | $JQ -r '.video')
      PROFILE_AUDIO=$(echo "$PROFILE" | $JQ -r '.audio')

      # Handle files
      echo "$PROFILE_NAME:"
      FILES=$($FIND "$PROFILE_DIR" -maxdepth 1 -type f -exec $BASENAME {} \;)
      for FILE in $FILES; do
        echo "  $FILE:"

        FILE_EXT="''${FILE##*.}"
        FILE_NAME=$($BASENAME "$FILE" ".$FILE_EXT")
        PROFILE_CONTAINER=$(echo "$PROFILE" | $JQ -r '.container')
        if [ "$PROFILE_CONTAINER" != "null" ]; then
          FILE_EXT="$PROFILE_CONTAINER"
        fi

        FFMPEG_COMMAND=($FFMPEG)
        HWACCEL=$(echo "$PROFILE" | $JQ -r '.hwaccel')
        if [ "$HWACCEL" != "null" ]; then
          FFMPEG_COMMAND+=(-hwaccel $HWACCEL)
        fi

        FFMPEG_COMMAND+=(-i "$PROFILE_DIR/$FILE")

        VIDEO_ENCODER=$(echo "$PROFILE_VIDEO" | $JQ -r '.encoder')
        if [ "$VIDEO_ENCODER" != "null" ]; then
          FFMPEG_COMMAND+=(-c:v $VIDEO_ENCODER)
        fi

        VIDEO_PRESET=$(echo "$PROFILE_VIDEO" | $JQ -r '.preset')
        if [ "$VIDEO_PRESET" != "null" ]; then
          FFMPEG_COMMAND+=(-preset $VIDEO_PRESET)
        fi

        VIDEO_QP=$(echo "$PROFILE_VIDEO" | $JQ -r '.qp')
        if [ "$VIDEO_QP" != "null" ]; then
          FFMPEG_COMMAND+=(-qp $VIDEO_QP)
        fi

        VIDEO_CFR=$(echo "$PROFILE_VIDEO" | $JQ -r '.cfr')
        if [ "$VIDEO_CFR" != "null" ]; then
          FFMPEG_COMMAND+=(-fps_mode cfr -r $VIDEO_CFR)
        fi

        VIDEO_VFR=$(echo "$PROFILE_VIDEO" | $JQ -r '.vfr')
        if [ "$VIDEO_VFR" != "null" ]; then
          FFMPEG_COMMAND+=(-fps_mode vfr -vf "fps=$VIDEO_VFR")
        fi

        VIDEO_CRF=$(echo "$PROFILE_VIDEO" | $JQ -r '.crf')
        if [ "$VIDEO_CRF" != "null" ]; then
          FFMPEG_COMMAND+=(-crf $VIDEO_CRF)
        fi

        VIDEO_BITRATE=$(echo "$PROFILE_VIDEO" | $JQ -r '.bitrate')
        if [ "$VIDEO_BITRATE" != "null" ]; then
          FFMPEG_COMMAND+=(-b:v $VIDEO_BITRATE)
        fi

        VIDEO_CUSTOM=$(echo "$PROFILE_VIDEO" | $JQ -r '.custom')
        if [ "$VIDEO_CUSTOM" != "null" ]; then
          FFMPEG_COMMAND+=($VIDEO_CUSTOM)
        fi

        AUDIO_ENCODER=$(echo "$PROFILE_AUDIO" | $JQ -r '.encoder')
        if [ "$AUDIO_ENCODER" != "null" ]; then
          FFMPEG_COMMAND+=(-c:a $AUDIO_ENCODER)
        fi

        AUDIO_BITRATE=$(echo "$PROFILE_AUDIO" | $JQ -r '.bitrate')
        if [ "$AUDIO_BITRATE" != "null" ]; then
          FFMPEG_COMMAND+=(-b:a $AUDIO_BITRATE)
        fi

        AUDIO_CUSTOM=$(echo "$PROFILE_AUDIO" | $JQ -r '.custom')
        if [ "$AUDIO_CUSTOM" != "null" ]; then
          FFMPEG_COMMAND+=($AUDIO_CUSTOM)
        fi

        LOG_LEVEL=$(echo "$PROFILE" | $JQ -r '.loglevel')
        if [ "$LOG_LEVEL" != "null" ]; then
          FFMPEG_COMMAND+=(-loglevel $LOG_LEVEL)
        fi

        FFMPEG_COMMAND+=("$OUT_DIR/$FILE_NAME.$FILE_EXT")
        FFMPEG_COMMAND+=(-y)

        echo "  >''${FFMPEG_COMMAND[@]}"
        "''${FFMPEG_COMMAND[@]}" > /dev/null
        if [ $? -eq 0 ]; then
          mv "$PROFILE_DIR/$FILE" "$SUCCESS_DIR/$FILE"
          echo "  > $FILE success ✅"
        else
          mv "$PROFILE_DIR/$FILE" "$FAILED_DIR/$FILE"
          echo "  > $FILE failed ❌"
        fi
        echo "=================================================="
      done
      IFS=$'\n'
    done
    IFS=$IFS_DEFAULT

    # Cleanup
    OLD_FILES=$($FIND "$PIPELINES_FFMPEG_DIR" -type f -ctime +7 -mtime +7 -not -name "*.directory" -not -name "*.sh" -not -name "*.json")
    IFS=$'\n'
    for OLD_FILE in $OLD_FILES; do
      echo "File $OLD_FILE is older than 7 days, removing it..."
      rm "$OLD_FILE"
    done
    IFS=$IFS_DEFAULT
  '';

  media-pipelines-ffmpeg-service = {
    Unit = {
      Description = "Media Pipelines (FFmpeg)";
      After = [ "multi-user.target" ];
      Wants = [ "multi-user.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${media-pipelines-ffmpeg}/bin/media-pipelines-ffmpeg";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  media-pipelines-ffmpeg-timer = {
    Unit = {
      Description = "Media Pipelines (FFmpeg)";
    };

    Timer = {
      OnCalendar = "minutely";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
in
{
  environment.systemPackages = [ media-pipelines-ffmpeg ];

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".systemd.user = {
      services.media-pipelines-ffmpeg = media-pipelines-ffmpeg-service;
      timers.media-pipelines-ffmpeg = media-pipelines-ffmpeg-timer;
    };
  });
}
