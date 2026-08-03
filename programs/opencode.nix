{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    opencode
    opencode-desktop
  ];
}
