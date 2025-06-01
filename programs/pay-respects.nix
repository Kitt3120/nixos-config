{ config, pkgs, ... }:

{
  programs.pay-respects = {
    enable = true;
    alias = "f";
  };
}
