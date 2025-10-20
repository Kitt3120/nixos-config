{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ rust-stakeholder ];
}
