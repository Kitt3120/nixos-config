{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dejavu_fonts
    liberation_ttf
    ubuntu_font_family
    freefont_ttf
    noto-fonts
    nerdfonts
    fira-code
  ];
}