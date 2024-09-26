{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nvtopPackages.full ];
}
