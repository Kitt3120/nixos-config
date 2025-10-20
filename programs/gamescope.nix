{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gamescope ];
}
