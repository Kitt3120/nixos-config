# Made possible by Sicheng-Pan (Macronova) (https://github.com/Sicheng-Pan)
# nixpkgs PR: https://github.com/NixOS/nixpkgs/pull/334984
# Checkout out the wallpaper-engine-kde-plugin-pkg.nix file for more information
# Thank you so much for this!

{
  config,
  pkgs,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    (pkgs.kdePackages.callPackage ./wallpaper-engine-kde-plugin-pkg.nix {
      lib = lib;
    })
  ];
}
