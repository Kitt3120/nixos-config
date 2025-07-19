{
  description = "Torben's machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:

    {
      nixosConfigurations = {
        modulosaurus = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit self system inputs; };
          modules = [
            ./configuration.nix
            ./_profiles/modulosaurus.nix
          ];
        };

        hydra = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit self system inputs; };
          modules = [
            ./configuration.nix
            ./_profiles/hydra.nix
          ];
        };

        "schweren.dev" = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit self system inputs; };
          modules = [
            ./configuration.nix
            ./_profiles/schweren.dev.nix
          ];
        };
      };
    };
}
