{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    python3Packages.pip
  ];
}
