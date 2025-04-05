{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ rust-stakeholder ];
}
