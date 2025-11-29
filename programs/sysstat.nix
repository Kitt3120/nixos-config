{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ sysstat ];
}
