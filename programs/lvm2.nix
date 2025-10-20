{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ lvm2 ];
}
