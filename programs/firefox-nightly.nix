{ config, pkgs, ... }:

{
  nixpkgs.overlays =
    let
      moz-rev = "master";
      moz-tarball = builtins.fetchTarball {
        #url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";
        url = "https://github.com/hneiva/nixpkgs-mozilla/archive/refs/heads/hneiva/xz-builds.zip"; # TODO: Change back when PR is merged:https://github.com/mozilla/nixpkgs-mozilla/pull/333
      };
      nightlyOverlay = (import "${moz-tarball}/firefox-overlay.nix");
    in
    [ nightlyOverlay ];

  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin;
  };
}
