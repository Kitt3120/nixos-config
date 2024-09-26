{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vintagestory ];
}
