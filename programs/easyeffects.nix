{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ easyeffects ];
}
