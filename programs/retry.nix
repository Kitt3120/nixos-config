{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ retry ];
}
