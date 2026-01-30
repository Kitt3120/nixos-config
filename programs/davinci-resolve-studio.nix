{ pkgs, ... }:

let
  source = builtins.readFile ../assets/scripts/davinci-fix-audio.sh;
  davinci-fix-audio = pkgs.writeShellApplication {
    name = "davinci-fix-audio";
    runtimeInputs = with pkgs; [
      bash
      ffmpeg
      coreutils
      findutils
    ];
    text = ''
      ${source}
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    davinci-resolve-studio
    davinci-fix-audio
  ];
}
