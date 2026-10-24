{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ bubblewrap ];
}
