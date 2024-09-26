{ config, pkgs, ... }:

# TODO: The button to open the terminal on failure is not working yet

let
  nixos-upgrade-notification-libnotify = (
    pkgs.writeShellScriptBin "nixos-upgrade-notification-libnotify" ''
      if ! command -v notify-send > /dev/null; then
        echo "libnotify is not installed. Please install it to enable upgrade notifications." >&2
        exit 1
      fi

      APP_NAME="NixOS"
      TITLE="Upgrade"

      echo "Sending upgrade start notification..."
      notify-send -a "$APP_NAME" -u "normal" "$TITLE" "Starting upgrade..."

      sleep 1 # Give nixos-upgrade.service some time to start

      echo "Waiting for nixos-upgrade.service to finish..."
      STATUS=$(systemctl is-active nixos-upgrade.service)
      while [[ "$STATUS" == "activating" ]]; do
        sleep 1
        STATUS=$(systemctl is-active nixos-upgrade.service)
      done
      echo "nixos-upgrade.service has finished"

      echo "nixos-upgrade.service status: $SERVICE_STATUS"

      if [[ $STATUS == "inactive" ]]; then
        echo "Sending success notification"
        notify-send -a "$APP_NAME" -u "normal" "$TITLE" "Completed successfully"
      else
        echo "Sending failure notification"
        ACTION=$(notify-send -a "$APP_NAME" -u "critical" --action "open=Show status" "$TITLE" "Failed with status $STATUS. Please check service status for more information.")
        if [[ $ACTION == "open" ]]; then
          konsole -e "systemctl status nixos-upgrade.service" &
          disown
        fi
      fi
    ''
  );
in
{
  environment.systemPackages = [ nixos-upgrade-notification-libnotify ];

  systemd.user.services.nixos-upgrade-notification-libnotify = {
    path = with pkgs; [
      libnotify
      systemd
      kdePackages.konsole
    ];

    description = "NixOS upgrade notification via libnotify";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nixos-upgrade-notification-libnotify";
    };

    wantedBy = [ "graphical-session.target" ];
  };

  systemd.user.timers.nixos-upgrade-notification-libnotify = {
    description = "Timer for NixOS upgrade notification via libnotify";

    timerConfig = {
      OnCalendar = config.system.autoUpgrade.dates;
      Persistent = config.system.autoUpgrade.persistent;
    };

    wantedBy = [ "graphical-session.target" ];
  };
}
