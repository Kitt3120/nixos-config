{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ tesseract ];
}
