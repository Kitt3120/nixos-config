{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ armitage ];
}
