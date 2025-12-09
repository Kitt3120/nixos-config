{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gavin-bc ];
}
