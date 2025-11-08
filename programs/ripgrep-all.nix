{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ripgrep-all ];
}
