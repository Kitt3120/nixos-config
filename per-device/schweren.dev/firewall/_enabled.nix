{ config, pkgs, ... }:

{
  imports = [
    ./mailcow.nix
    ./minecraft-mdj.nix
  ];
}
