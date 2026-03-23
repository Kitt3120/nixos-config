{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.nixpkgs-winboat.legacyPackages.${pkgs.system}.winboat
  ];
}
