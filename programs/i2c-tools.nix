{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ i2c-tools ];
}
