{ config, pkgs, ... }:

let
  media-pipelines-handbrake = (
    pkgs.writeShellScriptBin "media-pipelines-handbrake" ''
      if ! command -v HandBrakeCLI > /dev/null; then
          echo "HandBrakeCLI is not installed. Please install it to run media-pipelines-handbrake." >&2
          exit 1
      fi

      if [ ! -f "/home/$(whoami)/.config/ghb/presets.json" ]; then
          echo "HandBrake presets file not found. Please run HandBrake GUI at least once to generate it." >&2
          exit 1
      fi

      function handbrake {
          mkdir -p HandBrake
          cd ./HandBrake

          IFS=$'\n'
          for profile in $(find . -maxdepth 1 -type d ! -name . -printf '%f\n')
          do
              echo "$profile:"

              mkdir -p "./$profile/Successful"
              mkdir -p "./$profile/Failed"
              mkdir -p "./$profile/Output"

              cd "./$profile"

              for file in $(find . -maxdepth 1 -type f \( -name "*.mp4" -o -name "*.mov" -o -name "*.avi" -o -name "*.wmv" -o -name "*.flv" -o -name "*.mkv" -o -name "*.webm" \))
              do
                  file=$(basename "$file")
                  echo -n "> $file..."
                  error_output=$(HandBrakeCLI -i "$file" -o "./Output/$file" --preset-import-gui -Z "$profile" 2>&1 >/dev/null)
                  if [ $? -eq 0 ]; then
                      mv "$file" "./Successful/$file"
                      echo -e "\r> $file ✅"
                  else
                      mv "$file" "./Failed/$file"
                      echo -e "\r> $file ❌: $error_output"
                  fi
              done

              cd ..
          done
          unset IFS

          cd ..
      }

      function cleanup {
          IFS=$'\n'
          for file in $(find . -type f -mtime +7 -not -name "*.sh" -not -name "*.directory")
          do
              echo "> $file"
              rm "$file"
          done
          unset IFS
      }

      previous_working_dir="$(pwd)"
      pipelines_dir="/home/$(whoami)/Pipelines"
      mkdir -p "$pipelines_dir"
      cd "$pipelines_dir"

      echo "Pipeline directory: $pipelines_dir"

      echo ""

      echo "Running HandBrake pipeline"
      handbrake

      echo ""

      cd "$pipelines_dir" # Just in case :)
      echo "Cleaning up old files"
      cleanup

      cd $previous_working_dir

      exit 0
    ''
  );

  media-pipelines-handbrake-service = {
    Unit = {
      Description = "Media Pipelines (HandBrake)";
      After = [ "multi-user.target" ];
      Wants = [ "multi-user.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${media-pipelines-handbrake}/bin/media-pipelines-handbrake";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  media-pipelines-handbrake-timer = {
    Unit = {
      Description = "Media Pipelines (HandBrake)";
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
  environment.systemPackages = [ media-pipelines-handbrake ];

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".systemd.user = {
      services.media-pipelines-handbrake = media-pipelines-handbrake-service;
      timers.media-pipelines-handbrake = media-pipelines-handbrake-timer;
    };
  });
}
