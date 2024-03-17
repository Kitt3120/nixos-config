{ config, pkgs, ... }:

{
  imports = [
    ./users/_enabled.nix
    ./kernel.nix
    ./cpu.nix
    ./hostname.nix
    #./networking.nix # TODO: Enable again
    ./gpu.nix
    ./services.nix
    ./desktop.nix
    ./programs.nix
  ];
}