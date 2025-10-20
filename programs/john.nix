{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ john ];
}
