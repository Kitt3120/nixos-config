{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ inkscape-with-extensions ];
}
