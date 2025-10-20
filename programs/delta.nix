{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ delta ];
}
