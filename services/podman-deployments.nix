{
  config,
  lib,
  pkgs,
  ...
}:

let
  quadletFormat = pkgs.formats.ini { listsAsDuplicateKeys = true; };

  containerSubmodule = lib.types.submodule {
    options = {
      networks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Logical names (keys of this deployment's `networks`) of the networks this container should be attached to.";
      };

      dependsOn = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Logical names (keys of this deployment's `containers`) of containers this container should be
          ordered after (`Wants=` + `After=`). This only expresses startup ordering, not a runtime
          dependency: a later failure of a dependency does not stop this container.
        '';
      };

      quadlet = lib.mkOption {
        type = quadletFormat.type;
        default = { };
        description = ''
          Native Quadlet `.container` configuration, close to the raw Quadlet INI format
          (see podman-systemd.unit(5)). Sections such as `Unit`, `Container`, `Service` and
          `Install` may be set here. `PartOf=`, startup ordering, default `Pull`/`LogDriver`/
          `Restart`/`RestartSec`/`TimeoutStartSec` and the resolved `Network=` entries are added
          automatically and may be overridden here.
        '';
        example = lib.literalExpression ''
          {
            Container = {
              Image = "docker.io/library/postgres:18";
              Volume = [ "/var/lib/example/database:/var/lib/postgresql" ];
            };
            Service.Restart = "always";
          }
        '';
      };
    };
  };

  networkSubmodule = lib.types.submodule {
    options = {
      quadlet = lib.mkOption {
        type = quadletFormat.type;
        default = { };
        description = ''
          Native Quadlet `.network` configuration, close to the raw Quadlet INI format
          (see podman-systemd.unit(5)). `PartOf=` and a default `NetworkName`/`NetworkDeleteOnStop`
          are added automatically and may be overridden here.
        '';
      };
    };
  };

  deploymentSubmodule = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the deployment. Used for the directory and namespacing generated systemd units.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = "Username to run the deployment as. Will be created as a system user if it doesn't exist.";
      };

      deploymentDirectory = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Exact directory for the deployment. Defaults to /var/lib/<user>/<name>.";
      };

      shell = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to assign a login shell to the auto-created system user. Uses fish if enabled, then zsh, then bash.";
      };

      preStart = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Shell commands run by a dedicated `podman-deployment-<name>-prepare.service` oneshot
          unit before the deployment's containers are ordered after it. Runs with the deployment
          directory as its working directory. Kept for compatibility; prefer plain Quadlet
          configuration (e.g. `EnvironmentFile=`) over abusing this for secrets handling.
        '';
      };

      ports = {
        tcp = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [ ];
          description = "TCP ports to open in the firewall.";
        };

        udp = lib.mkOption {
          type = lib.types.listOf lib.types.port;
          default = [ ];
          description = "UDP ports to open in the firewall.";
        };
      };

      networks = lib.mkOption {
        type = lib.types.attrsOf networkSubmodule;
        default = { };
        description = "Podman networks to create for this deployment as rootless Quadlets, keyed by logical name.";
      };

      containers = lib.mkOption {
        type = lib.types.attrsOf containerSubmodule;
        default = { };
        description = "Podman containers to run for this deployment as rootless Quadlets, keyed by logical name.";
      };
    };
  };

  # Pure DFS cycle check: is `containerName` reachable from itself via dependsOn edges?
  # `visiting` is the current path (recursion stack), used to detect back-edges.
  dependencyCycleFrom =
    containers: visiting: containerName:
    if builtins.elem containerName visiting then
      true
    else
      let
        containerNames = builtins.attrNames containers;
        deps = builtins.filter (
          dep: builtins.elem dep containerNames
        ) containers.${containerName}.dependsOn;
      in
      builtins.any (dependencyCycleFrom containers (visiting ++ [ containerName ])) deps;

  deploymentAssertions =
    deployment:
    let
      containerNames = builtins.attrNames deployment.containers;
      networkNames = builtins.attrNames deployment.networks;

      unknownDependsOn = lib.concatMap (
        containerName:
        map (dep: { inherit containerName dep; }) (
          builtins.filter (
            dep: !(builtins.elem dep containerNames)
          ) deployment.containers.${containerName}.dependsOn
        )
      ) containerNames;

      unknownNetworks = lib.concatMap (
        containerName:
        map (net: { inherit containerName net; }) (
          builtins.filter (
            net: !(builtins.elem net networkNames)
          ) deployment.containers.${containerName}.networks
        )
      ) containerNames;

      selfDependingContainers = builtins.filter (
        containerName: builtins.elem containerName deployment.containers.${containerName}.dependsOn
      ) containerNames;

      containersWithoutImage = builtins.filter (
        containerName: (deployment.containers.${containerName}.quadlet.Container.Image or null) == null
      ) containerNames;

      containersInCycle = builtins.filter (
        containerName:
        dependencyCycleFrom deployment.containers [ ] containerName
        && !(builtins.elem containerName selfDependingContainers)
      ) containerNames;

      prepareNameCollision = deployment.preStart != "" && builtins.elem "prepare" containerNames;
    in
    [
      {
        assertion = deployment.containers != { };
        message = "settings.podman.deployments: deployment '${deployment.name}' has no containers defined.";
      }
    ]
    ++ map (e: {
      assertion = false;
      message = "settings.podman.deployments: container '${e.containerName}' in deployment '${deployment.name}' has dependsOn entry '${e.dep}', which is not a container of this deployment.";
    }) unknownDependsOn
    ++ map (e: {
      assertion = false;
      message = "settings.podman.deployments: container '${e.containerName}' in deployment '${deployment.name}' references unknown network '${e.net}'.";
    }) unknownNetworks
    ++ map (containerName: {
      assertion = false;
      message = "settings.podman.deployments: container '${containerName}' in deployment '${deployment.name}' depends on itself.";
    }) selfDependingContainers
    ++ map (containerName: {
      assertion = false;
      message = "settings.podman.deployments: container '${containerName}' in deployment '${deployment.name}' has no [Container] Image= set.";
    }) containersWithoutImage
    ++ map (containerName: {
      assertion = false;
      message = "settings.podman.deployments: container '${containerName}' in deployment '${deployment.name}' participates in a dependsOn cycle.";
    }) containersInCycle
    ++ lib.optional prepareNameCollision {
      assertion = false;
      message = "settings.podman.deployments: deployment '${deployment.name}' has a container named 'prepare', which collides with the generated prepare service name.";
    };

  deploymentNameCounts = lib.foldl' (
    acc: deployment: acc // { ${deployment.name} = (acc.${deployment.name} or 0) + 1; }
  ) { } config.settings.podman.deployments;

  duplicateDeploymentNames = builtins.attrNames (
    lib.filterAttrs (_: count: count > 1) deploymentNameCounts
  );
in
{
  options.settings.podman.deployments = lib.mkOption {
    type = lib.types.listOf deploymentSubmodule;
    default = [ ];
    description = "List of Podman deployments to manage as rootless Quadlets under a systemd --user manager.";
  };

  config = lib.mkIf (config.settings.podman.deployments != [ ]) {
    assertions = [
      {
        assertion = duplicateDeploymentNames == [ ];
        message = "settings.podman.deployments: duplicate deployment name(s): ${lib.concatStringsSep ", " duplicateDeploymentNames}";
      }
    ]
    ++ lib.concatMap deploymentAssertions config.settings.podman.deployments;

    # Create system users for deployment users not already in allUsers
    users.users = lib.foldl' (
      acc: deployment:
      if builtins.elem deployment.user config.allUsers then
        acc
        // {
          ${deployment.user} = {
            linger = lib.mkDefault true;
          };
        }
      else
        acc
        // {
          ${deployment.user} = {
            isSystemUser = true;
            group = deployment.user;
            home = "/var/lib/${deployment.user}";
            createHome = true;
            linger = true;
            autoSubUidGidRange = true;
          }
          // lib.optionalAttrs deployment.shell {
            shell =
              if config.programs.fish.enable then
                pkgs.fish
              else if config.programs.zsh.enable then
                pkgs.zsh
              else
                pkgs.bash;
          };
        }
    ) { } config.settings.podman.deployments;

    # Create groups for new system users
    users.groups = lib.foldl' (
      acc: deployment:
      if builtins.elem deployment.user config.allUsers then acc else acc // { ${deployment.user} = { }; }
    ) { } config.settings.podman.deployments;

    # Ensure deployment directories exist with correct ownership
    systemd.tmpfiles.rules = lib.concatMap (
      deployment:
      let
        effectiveDeploymentDir =
          if deployment.deploymentDirectory != null then
            deployment.deploymentDirectory
          else
            "/var/lib/${deployment.user}/${deployment.name}";
      in
      [ "d ${effectiveDeploymentDir} 0755 ${deployment.user} - -" ]
    ) config.settings.podman.deployments;

    # Set up systemd user services via home-manager
    home-manager.users = lib.foldl' (
      acc: deployment:
      let
        effectiveDeploymentDir =
          if deployment.deploymentDirectory != null then
            deployment.deploymentDirectory
          else
            "/var/lib/${deployment.user}/${deployment.name}";

        podmanDeployment = config.mkPodmanDeployment {
          inherit (deployment)
            name
            preStart
            networks
            containers
            ;
          deploymentDirectory = effectiveDeploymentDir;
        };

        existing = acc.${deployment.user} or { };

        quadletHomeFiles = lib.mapAttrs' (
          fileName: source: lib.nameValuePair ".config/containers/systemd/${fileName}" { inherit source; }
        ) podmanDeployment.quadletFiles;
      in
      acc
      // {
        ${deployment.user} = existing // {
          home.stateVersion = config.system.stateVersion;

          home.packages = (existing.home.packages or [ ]) ++ [ podmanDeployment.scripts.cli ];

          home.file = (existing.home.file or { }) // quadletHomeFiles;

          systemd.user.services =
            (existing.systemd.user.services or { })
            // {
              "podman-deployment-${deployment.name}" = podmanDeployment.controllerService;
            }
            // (lib.optionalAttrs (podmanDeployment.prepareService != null) {
              "podman-deployment-${deployment.name}-prepare" = podmanDeployment.prepareService;
            });

          systemd.user.targets = (existing.systemd.user.targets or { }) // {
            "podman-deployment-${deployment.name}" = podmanDeployment.target;
          };
        };
      }
    ) { } config.settings.podman.deployments;

    # Open firewall ports
    networking.firewall = {
      allowedTCPPorts = lib.concatMap (d: d.ports.tcp) config.settings.podman.deployments;
      allowedUDPPorts = lib.concatMap (d: d.ports.udp) config.settings.podman.deployments;
    };
  };
}
