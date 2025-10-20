{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ qrtool ];
}
