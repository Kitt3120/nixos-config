{ config, pkgs, lib, ... }:

{
  options = {
    mapAllUsers = lib.mkOption {
      default = perUserFunction: map(user: (perUserFunction) user) config.allUsers;
      type = lib.types.anything;
    };

    mapAllUsersToSet = lib.mkOption {
      default = perUserFunction: lib.foldl(users: user: (users // user)) {} (config.mapAllUsers (perUserFunction));
      type = lib.types.anything;
    };
  };
}