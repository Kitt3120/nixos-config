{ pkgs, inputs, ... }:

{
  environment.systemPackages = [ pkgs.winboat ];
}
