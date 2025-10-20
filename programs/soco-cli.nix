{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ soco-cli ];
}
