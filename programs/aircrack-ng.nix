{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ aircrack-ng ];
}
