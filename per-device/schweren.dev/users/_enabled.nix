{ config, pkgs, ... }:

{
  imports = [
    ./minecraft/_enabled.nix
    ./torben/_enabled.nix
  ];
}
