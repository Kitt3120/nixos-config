{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    retroarch-full
    retroarch-assets
  ];
}
