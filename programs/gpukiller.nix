{ pkgs, ... }:

let
  source = builtins.readFile ../assets/scripts/gpukiller.sh;
  gpukiller = pkgs.writeShellScriptBin "gpukiller" ''
    ${source}
  '';
in
{
  environment.systemPackages = [ gpukiller ];
}
