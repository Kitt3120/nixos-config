{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ parted ];
}
