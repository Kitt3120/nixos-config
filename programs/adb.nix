{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pkgs.android-tools ];
}
