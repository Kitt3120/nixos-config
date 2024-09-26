{ config, pkgs, ... }:

{
  environment.systemPackages =
    let
      vscode-insiders = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
        src = (
          builtins.fetchTarball {
            url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
          }
        );
        version = "latest";
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
      });
    in
    with pkgs;
    [ vscode-insiders ];
}
