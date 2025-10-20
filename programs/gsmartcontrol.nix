{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gsmartcontrol ];
}
