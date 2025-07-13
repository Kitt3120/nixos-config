{ config, pkgs, ... }:

{
  imports = [
    ./global/functions.nix
    ./global/networking.nix
    ./global/programs.nix
    ./global/services.nix
    ./global/system.nix
    ./global/users.nix
  ];
}
