{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pigz ];
}
