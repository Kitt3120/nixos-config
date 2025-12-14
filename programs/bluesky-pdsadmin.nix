{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bluesky-pdsadmin ];
}
