{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.settings.protonup;

  protonGeAutoUpdate = pkgs.writeShellApplication {
    name = "proton-ge-auto-update";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gnutar
      pkgs.gnused
      pkgs.protonup-ng
    ];
    text = ''
      log() {
        printf '[%s] %s\n' "$(date --iso-8601=seconds)" "$*"
      }

      log "Checking available GE-Proton releases..."
      if ! available_releases="$(protonup --releases)"; then
        log "ERROR: Failed to fetch available releases." >&2
        exit 1
      fi
      latest_version="$(printf '%s\n' "$available_releases" | sort -V | tail -n 1)"

      if [[ ! "$latest_version" =~ ^GE-Proton[0-9]+-[0-9]+$ ]]; then
        log "ERROR: Could not determine the latest GE-Proton release." >&2
        exit 1
      fi
      log "Latest available release: $latest_version"

      install_directory_output="$(protonup --dir get)"
      install_directory="$(printf '%s\n' "$install_directory_output" | sed -n "s/^Install directory set to '\\(.*\\)'$/\\1/p")"
      if [[ -z "$install_directory" ]]; then
        log "ERROR: Could not determine the Proton installation directory." >&2
        exit 1
      fi
      install_directory="''${install_directory%/}"
      target_directory="$install_directory/$latest_version-x86_64"
      state_directory="''${XDG_STATE_HOME:-$HOME/.local/state}/proton-ge-auto-update"
      state_marker="$state_directory/$latest_version"

      if [[ ! -f "$state_marker" || ! -f "$target_directory/proton" ]]; then
        mkdir -p "$install_directory" "$state_directory"
        work_directory="$(mktemp -d)"
        trap 'rm -rf -- "$work_directory"' EXIT
        download_directory="$work_directory/download"
        mkdir -p "$download_directory"

        log "Downloading checksum-verified archive for $latest_version..."
        if ! protonup --download --tag "$latest_version" --yes --output "$download_directory"; then
          log "ERROR: Failed to download $latest_version." >&2
          exit 1
        fi

        shopt -s nullglob
        archives=("$download_directory"/*.tar.gz)
        if [[ ''${#archives[@]} -ne 1 ]]; then
          log "ERROR: Expected one Proton archive, found ''${#archives[@]}." >&2
          exit 1
        fi
        archive="''${archives[0]}"

        log "Replacing any incomplete installation of $latest_version..."
        rm -rf -- "$target_directory"
        log "Extracting $latest_version..."
        if ! tar --extract --gzip --file "$archive" --directory "$install_directory" --no-same-owner; then
          log "ERROR: Failed to extract $latest_version." >&2
          exit 1
        fi
        if [[ ! -f "$target_directory/proton" ]]; then
          log "ERROR: Extracted archive does not contain a Proton executable." >&2
          exit 1
        fi

        touch "$state_marker"
        log "Installed $latest_version successfully."
      else
        log "Latest version is already installed; skipping download."
      fi

      log "Removing older GE-Proton versions..."
      older_version_found=false
      for installed_directory in "$install_directory"/GE-Proton*; do
        [[ -d "$installed_directory" ]] || continue
        installed_name="''${installed_directory##*/}"
        if [[ "$installed_name" =~ ^GE-Proton[0-9]+-[0-9]+(-x86_64)?$ ]] && [[ "$installed_directory" != "$target_directory" ]] && [[ -f "$installed_directory/proton" ]]; then
          older_version_found=true
          log "Removing older version $installed_name..."
          rm -rf -- "$installed_directory"
          log "Removed $installed_name successfully."
        fi
      done

      if [[ "$older_version_found" == false ]]; then
        log "No older GE-Proton versions to remove."
      fi
      log "GE-Proton update check completed."
    '';
  };
in
{
  options.settings.protonup = {
    autoUpdate = lib.mkOption {
      type = lib.types.bool;
      default = config.programs.steam.enable;
      description = "Enable automatic updates for Steam GE-Proton via protonup-ng.";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      protonup-ng
      protonup-qt
    ];

    home-manager.users = lib.mkIf cfg.autoUpdate (
      config.mapAllUsersToSet (user: {
        "${user}" = {
          systemd.user.services.proton-ge-auto-update = {
            Unit.Description = "Update Steam GE-Proton and remove older versions";
            Service = {
              Type = "oneshot";
              ExecStart = "${protonGeAutoUpdate}/bin/proton-ge-auto-update";
              StandardOutput = "journal";
              StandardError = "journal";
              SyslogIdentifier = "proton-ge-auto-update";
            };
          };

          systemd.user.timers.proton-ge-auto-update = {
            Unit.Description = "Check for Steam GE-Proton updates daily";
            Timer = {
              OnCalendar = "daily";
              Persistent = true;
              RandomizedDelaySec = "1h";
            };
            Install.WantedBy = [ "timers.target" ];
          };
        };
      })
    );
  };
}
