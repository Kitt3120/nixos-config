{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ zoxide ];

  programs.bash.interactiveShellInit = "eval $(zoxide init --cmd cd bash)";
  programs.zsh.interactiveShellInit = lib.mkIf config.programs.zsh.enable "eval $(zoxide init --cmd cd zsh)";
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable "zoxide init --cmd cd fish | source";
}
