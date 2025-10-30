{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonup-ng
    protonup-qt
  ];
}
