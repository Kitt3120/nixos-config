{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gh
    github-copilot-cli
  ];
}
