{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.settings.podman.deployments = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Name of the deployment. Used for the directory and systemd service name.";
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

          compose = lib.mkOption {
            type = lib.types.str;
            description = "Contents of the compose.yml file.";
          };

          preStart = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Shell commands executed after pulling images and before starting the deployment.";
          };

          shell = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to assign a login shell to the auto-created system user. Uses fish if enabled, then zsh, then bash.";
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
        };
      }
    );
    default = [ ];
    description = "List of Podman Compose deployments to manage as systemd user services.";
  };

  config = lib.mkIf (config.settings.podman.deployments != [ ]) {
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
      if builtins.elem deployment.user config.allUsers then
        acc
      else
        acc
        // {
          ${deployment.user} = { };
        }
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
      [
        "d ${effectiveDeploymentDir} 0755 ${deployment.user} - -"
      ]
    ) config.settings.podman.deployments;

    # Set up systemd user services via home-manager
    home-manager.users = lib.foldl' (
      acc: deployment:
      let
        podmanDeployment = config.mkPodmanDeployment {
          inherit (deployment)
            name
            compose
            preStart
            ;
          deploymentDirectory =
            if deployment.deploymentDirectory != null then
              deployment.deploymentDirectory
            else
              "/var/lib/${deployment.user}/${deployment.name}";
        };
      in
      acc
      // {
        ${deployment.user} = acc.${deployment.user} or { } // {
          home.stateVersion = config.system.stateVersion;

          home.packages = (acc.${deployment.user}.home.packages or [ ]) ++ [
            podmanDeployment.scripts.cli
          ];

          systemd.user.services = (acc.${deployment.user}.systemd.user.services or { }) // {
            "podman-deployment-${deployment.name}" = podmanDeployment.systemd.unit;
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
