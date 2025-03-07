{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ rustup ];

  programs.bash.interactiveShellInit = "export PATH=\"$HOME/.cargo/bin:$PATH\"";
  programs.zsh.interactiveShellInit = lib.mkIf config.programs.zsh.enable "export PATH=\"$HOME/.cargo/bin:$PATH\"";
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable "fish_add_path $HOME/.cargo/bin";
}
