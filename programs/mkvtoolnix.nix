{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mkvtoolnix
    mkvtoolnix-cli
  ];
}
