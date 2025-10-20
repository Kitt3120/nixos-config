{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ani-cli ];
}
