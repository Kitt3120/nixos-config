{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pear-desktop ];
}
