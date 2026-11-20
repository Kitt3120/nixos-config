{ ... }:

{
  imports = [
    ./home-manager.nix
    ./sops.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # TODO: Keep as minimal as possible
  nixpkgs.config.permittedInsecurePackages = [ ];
}
