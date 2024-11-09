{ pkgs, ... }:

# TODO: Remove overrideAttrs workaround and commit the fix to nixpkgs
{
  environment.systemPackages = [
    (pkgs.evillimiter.overrideAttrs (oldAttrs: rec {
      propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [
        pkgs.python3Packages.setuptools
        pkgs.python3Packages.setuptools-scm
      ];
    }))
  ];
}
