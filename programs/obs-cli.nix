{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ obs-cli ];
}
