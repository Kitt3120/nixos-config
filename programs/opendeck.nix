{ inputs, ... }:

{
  imports = [ inputs.opendeck-nix.nixosModules.default ];
  programs.opendeck.enable = true;
}
