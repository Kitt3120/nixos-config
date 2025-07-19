{
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.aagl.nixosModules.default
  ];

  programs.anime-games-launcher.enable = true;

  programs.anime-game-launcher.enable = false;
  programs.honkers-railway-launcher.enable = false;
  programs.honkers-launcher.enable = false;
  programs.wavey-launcher.enable = false;
  programs.sleepy-launcher.enable = false;
}
