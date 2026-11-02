{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gtk3
    gtk4
  ];
}
