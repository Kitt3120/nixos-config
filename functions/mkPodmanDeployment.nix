{ pkgs, lib, ... }:

{
  options.mkPodmanDeployment = lib.mkOption {
    default =
      {
        name,
        deploymentDirectory,
        preStart ? "",
        networks ? { },
        containers ? { },
      }:
      let
        quadletFormat = pkgs.formats.ini { listsAsDuplicateKeys = true; };

        deploymentPrefix = "podman-deployment-${name}";
        targetUnit = "${deploymentPrefix}.target";
        controllerUnit = "${deploymentPrefix}.service";
        prepareUnit = "${deploymentPrefix}-prepare.service";
        hasPrepareStep = preStart != "";

        containerFileName = containerName: "${deploymentPrefix}-${containerName}.container";
        containerServiceName = containerName: "${deploymentPrefix}-${containerName}.service";
        networkFileName = networkName: "${deploymentPrefix}-${networkName}.network";

        # Podman's Quadlet generator derives the systemd service name of a `.network` unit by
        # appending `-network` to its base name, so it can't collide with a `.container` unit of
        # the same logical name (e.g. a network and a container both called "eternity").
        networkServiceName = networkName: "${deploymentPrefix}-${networkName}-network.service";

        # `PartOf=` propagates stop/restart from the referenced unit down to the unit declaring
        # it. The controller only stops/restarts the target, the target only stops/restarts the
        # containers/networks/prepare step - none of them ever start or stop containers directly.
        mergeNetworkQuadlet =
          networkName: networkCfg:
          let
            existingUnit = networkCfg.quadlet.Unit or { };
            existingNetwork = networkCfg.quadlet.Network or { };

            networkDefaults = {
              NetworkName = "${deploymentPrefix}-${networkName}";
              NetworkDeleteOnStop = true;
            };
          in
          networkCfg.quadlet
          // {
            Unit = existingUnit // {
              PartOf = lib.toList (existingUnit.PartOf or [ ]) ++ [ targetUnit ];
            };
            Network = networkDefaults // existingNetwork;
          };

        mergeContainerQuadlet =
          containerName: containerCfg:
          let
            existingUnit = containerCfg.quadlet.Unit or { };
            existingContainer = containerCfg.quadlet.Container or { };
            existingService = containerCfg.quadlet.Service or { };

            # Wants+After only express startup ordering, deliberately not Requires+After: a later
            # failure of a dependency should not tear down the services that depend on it.
            dependencyUnits = map containerServiceName containerCfg.dependsOn;
            orderingUnits = dependencyUnits ++ lib.optional hasPrepareStep prepareUnit;

            containerDefaults = {
              Pull = "newer";
              LogDriver = "journald";
            };

            serviceDefaults = {
              Restart = "always";
              RestartSec = "5s";
              TimeoutStartSec = 900;
            };
          in
          containerCfg.quadlet
          // {
            Unit = existingUnit // {
              PartOf = lib.toList (existingUnit.PartOf or [ ]) ++ [ targetUnit ];
              Wants = lib.toList (existingUnit.Wants or [ ]) ++ orderingUnits;
              After = lib.toList (existingUnit.After or [ ]) ++ orderingUnits;
            };
            Container =
              containerDefaults
              // existingContainer
              // {
                Network =
                  lib.toList (existingContainer.Network or [ ]) ++ map networkFileName containerCfg.networks;
              };
            Service = serviceDefaults // existingService;
          };

        networkFiles = lib.mapAttrs' (
          networkName: networkCfg:
          lib.nameValuePair (networkFileName networkName) (
            quadletFormat.generate (networkFileName networkName) (mergeNetworkQuadlet networkName networkCfg)
          )
        ) networks;

        containerFiles = lib.mapAttrs' (
          containerName: containerCfg:
          lib.nameValuePair (containerFileName containerName) (
            quadletFormat.generate (containerFileName containerName) (
              mergeContainerQuadlet containerName containerCfg
            )
          )
        ) containers;

        quadletFiles = networkFiles // containerFiles;

        containerServiceNames = map containerServiceName (builtins.attrNames containers);
        networkServiceNames = map networkServiceName (builtins.attrNames networks);

        prepareScript = pkgs.writeShellScript "${deploymentPrefix}-prepare" ''
          cd "${deploymentDirectory}"
          ${preStart}
        '';

        controllerService = {
          Unit = {
            Description = "Podman deployment ${name}";
            Wants = [ targetUnit ];
            After = [ targetUnit ];
            # Restart the controller (and thus, via PartOf, the whole deployment) whenever any
            # generated Quadlet file changes.
            X-Restart-Triggers = builtins.attrValues quadletFiles;
          };

          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.coreutils}/bin/true";
          };

          Install.WantedBy = [ "default.target" ];
        };

        target = {
          Unit = {
            Description = "Podman deployment ${name} target";
            PartOf = [ controllerUnit ];
            Wants = containerServiceNames;
            After = containerServiceNames;
          };
        };

        prepareService =
          if hasPrepareStep then
            {
              Unit = {
                Description = "Prepare Podman deployment ${name}";
                PartOf = [ targetUnit ];
              };

              Service = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStart = "${prepareScript}";
              };
            }
          else
            null;

        scriptCli =
          let
            systemctl = "${pkgs.systemd}/bin/systemctl";
            journalctl = "${pkgs.systemd}/bin/journalctl";
            statusUnits = [
              controllerUnit
              targetUnit
            ]
            ++ containerServiceNames
            ++ networkServiceNames;
            logArgs = lib.concatMapStringsSep " " (unit: "-u ${unit}") containerServiceNames;
          in
          pkgs.writeShellScriptBin "podman-deployment-${name}" ''
            function start {
              ${systemctl} --user start "${controllerUnit}"
              echo "${name} started"
            }

            function stop {
              ${systemctl} --user stop "${controllerUnit}"
              echo "${name} stopped"
            }

            function restart {
              ${systemctl} --user restart "${controllerUnit}"
              echo "${name} restarted"
            }

            function status {
              ${systemctl} --user status ${lib.concatStringsSep " " statusUnits}
            }

            function logs {
              ${journalctl} --user -f ${logArgs}
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

            case "$1" in
              start|stop|restart|status|logs)
                "$1"
                ;;
              "")
                menu
                ;;
              *)
                echo "Usage: podman-deployment-${name} {start|stop|restart|status|logs}"
                exit 1
                ;;
            esac
          '';
      in
      {
        inherit
          quadletFiles
          controllerService
          target
          prepareService
          ;

        scripts = {
          cli = scriptCli;
        };

        serviceNames = {
          containers = containerServiceNames;
          networks = networkServiceNames;
        };
      };
    type = lib.types.anything;
  };
}
