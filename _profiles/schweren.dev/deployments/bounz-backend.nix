{ pkgs, ... }:

{
  # Watchtower talks to the Podman REST API to see and update containers, which rootless Podman
  # doesn't expose by default. Enable it just for this deployment's user, socket-activated so it
  # only actually runs while something is connected to it.
  home-manager.users.bounz-backend.systemd.user.sockets.podman = {
    Unit.Description = "Podman API Socket";
    Socket = {
      ListenStream = "%t/podman/podman.sock";
      SocketMode = "0660";
    };
    Install.WantedBy = [ "sockets.target" ];
  };

  home-manager.users.bounz-backend.systemd.user.services.podman = {
    Unit.Description = "Podman API Service";
    Service.ExecStart = "${pkgs.podman}/bin/podman system service";
  };

  settings.podman.deployments = [
    {
      name = "bounz-backend";
      user = "bounz-backend";
      shell = true;

      ports.tcp = [ 28080 ];

      containers = {
        bounz-backend = {
          quadlet = {
            Unit = {
              Description = "Bounz backend";
            };

            Container = {
              Image = "docker.io/dockenog/bounz-backend:latest";
              PublishPort = [ "28080:8080" ];
              # Picked up by this deployment's own Watchtower instance below.
              Label = "com.centurylinklabs.watchtower.enable=true";
            };
          };
        };

        watchtower = {
          quadlet = {
            Unit = {
              Description = "Watchtower for Bounz backend";
              Wants = [ "podman.socket" ];
              After = [ "podman.socket" ];
            };

            Container = {
              Image = "docker.io/containrrr/watchtower:latest";
              Volume = "%t/podman/podman.sock:/var/run/docker.sock";
              Environment = [
                "DOCKER_HOST=unix:///var/run/docker.sock"
                "WATCHTOWER_LABEL_ENABLE=true"
                "WATCHTOWER_POLL_INTERVAL=1800"
              ];
            };
          };
        };
      };
    }
  ];
}
