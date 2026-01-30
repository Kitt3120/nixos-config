{ pkgs, ... }:

let
  davinci-fix-audio = pkgs.writeShellApplication {
    name = "davinci-fix-audio";
    runtimeInputs = with pkgs; [
      bash
      ffmpeg
      coreutils
      findutils
    ];
    text = builtins.readFile ../assets/scripts/davinci-fix-audio.sh;
  };
in
{
  environment.systemPackages = [
    pkgs.davinci-resolve-studio
    davinci-fix-audio
  ];
}
