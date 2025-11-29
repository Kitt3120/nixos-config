{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ iotop ];
}
