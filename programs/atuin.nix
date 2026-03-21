{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ atuin ];

  programs.bash.interactiveShellInit = "eval $(atuin init bash)";
  programs.zsh.interactiveShellInit = lib.mkIf config.programs.zsh.enable "eval $(atuin init zsh)";
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable "atuin init fish | source";
}
