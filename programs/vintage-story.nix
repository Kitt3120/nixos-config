{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vintagestory ];

  # TODO: Remove when upstream supports / nixpkgs uses .NET >7
  # https://github.com/NixOS/nixpkgs/issues/360384
  # https://github.com/NixOS/nixpkgs/issues/326335
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-7.0.20"
    "dotnet-runtime-wrapped-7.0.20"
  ];
}
