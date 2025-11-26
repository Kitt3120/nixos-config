{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ piper ];
}
