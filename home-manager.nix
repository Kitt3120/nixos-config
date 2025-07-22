{ config, inputs, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # The state version is required and should stay at the version you originally installed.
  # Similar to the system.stateVersion.
  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".home.stateVersion = config.system.stateVersion;
  });
}
