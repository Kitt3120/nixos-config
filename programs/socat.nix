{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ socat ];
}
