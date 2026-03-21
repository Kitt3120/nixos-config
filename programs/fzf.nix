{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ fzf ];

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
}
