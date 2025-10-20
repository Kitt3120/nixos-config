{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ dfc ];
}
