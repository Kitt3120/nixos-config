{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ onlyoffice-bin_latest ];
}
