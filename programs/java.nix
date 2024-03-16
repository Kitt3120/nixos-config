{ config, pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.openjdk21; # Set to same as first Java below
  };
  
  environment.systemPackages = with pkgs; [ 
    # First option is default Java
    openjdk21
    openjdk17
    openjdk8
   ];
}