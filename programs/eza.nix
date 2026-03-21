{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ eza ];

  programs.bash.shellAliases.tree = "eza --tree";
  programs.zsh.shellAliases.tree = "eza --tree";
  programs.fish.shellAliases.tree = "eza --tree";
}
