{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ pdfarranger ];
}
