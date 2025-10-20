{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ xfsprogs ];
}
