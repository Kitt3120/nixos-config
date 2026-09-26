{ pkgs, ... }:

{
  # We set this to false on purpose to avoid too aggressive tuning done by powertop --auto-tune
  powerManagement.powertop.enable = false;

  # We just want to have the CLI tool available
  environment.systemPackages = [ pkgs.powertop ];
}
