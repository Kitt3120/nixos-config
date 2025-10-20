{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nvd ];
}
