{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ uni-sync ];
}
