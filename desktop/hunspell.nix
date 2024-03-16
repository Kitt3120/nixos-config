{ config, pkgs, ... }:

{
   environment.systemPackages = with pkgs; [ 
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_GB-large
    hunspellDicts.de_DE
   ];
}