{ config, pkgs, ... }:

{
  nixpkgs.overlays =
    let
      moz-rev = "master";
      moz-tarball = builtins.fetchTarball {
        url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";
      };
      nightlyOverlay = (import "${moz-tarball}/firefox-overlay.nix");
    in
    [ nightlyOverlay ];

  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin;
  };
}
