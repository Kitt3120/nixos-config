{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ryubing ];
}
