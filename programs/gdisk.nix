{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ gptfdisk ];
}
