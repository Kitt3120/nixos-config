{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ scrub ];
}
