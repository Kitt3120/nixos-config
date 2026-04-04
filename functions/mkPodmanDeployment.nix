{ pkgs, lib, ... }:

{
  options.mkPodmanDeployment = lib.mkOption {
    default =
      {
        name,
        workingDirectory,
        compose,
      }:
      let
        deploymentDir = "${workingDirectory}/${name}";
        composeFile = pkgs.writeText "${name}-compose.yml" compose;

        script-cli =
          with pkgs;
          (writeShellScriptBin "podman-deployment-${name}" ''
            function start {
              systemctl --user start podman-deployment-${name}
              echo "${name} started"
            }

            function stop {
              systemctl --user stop podman-deployment-${name}
              echo "${name} stopped"
            }

            function restart {
              systemctl --user restart podman-deployment-${name}
              echo "${name} restarted"
            }

            function status {
              systemctl --user status podman-deployment-${name}
            }

            function logs {
              export PATH="${podman}/bin:$PATH"
              cd "${deploymentDir}"
              ${podman-compose}/bin/podman-compose logs -f
            }

            function menu {
              echo "Podman deployment: ${name}"
              echo ""
              echo "1) Start"
              echo "2) Stop"
              echo "3) Restart"
              echo "4) Status"
              echo "5) Logs"

              read option
              case "$option" in
                1) start ;;
                2) stop ;;
                3) restart ;;
                4) status ;;
                5) logs ;;
                *) menu ;;
              esac
            }

            menu
          '');

        script-start =
          with pkgs;
          (writeShellScriptBin "podman-deployment-${name}-start" ''
            export PATH="${podman}/bin:$PATH"
            ${coreutils}/bin/mkdir -p "${deploymentDir}"
            ${coreutils}/bin/cp -f "${composeFile}" "${deploymentDir}/compose.yml"
            cd "${deploymentDir}"
            ${podman-compose}/bin/podman-compose down || true
            ${podman-compose}/bin/podman-compose pull
            ${podman-compose}/bin/podman-compose up -d --build
          '');

        script-stop =
          with pkgs;
          (writeShellScriptBin "podman-deployment-${name}-stop" ''
            export PATH="${podman}/bin:$PATH"
            cd "${deploymentDir}"
            ${podman-compose}/bin/podman-compose down
          '');
      in
      {
        scripts = {
          cli = script-cli;
          start = script-start;
          stop = script-stop;
        };

        systemd.unit = {
          Unit = {
            Description = "Podman deployment ${name}";
            After = [ "network.target" ];
            Wants = [ "network.target" ];
          };

          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${script-start}/bin/podman-deployment-${name}-start";
            ExecStop = "${script-stop}/bin/podman-deployment-${name}-stop";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    type = lib.types.anything;
  };
}
