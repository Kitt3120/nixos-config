{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ smartmontools ];
}
