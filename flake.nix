{
  description = "Torben's machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=599ddd2b79331c1e6153e1659bdaab65d62c4c82"; # nixos-unstable last good davinci resolve
    #nixpkgs.url = "path:/home/torben/Nextcloud/Programmierung/NixOS/nixpkgs"; # local

    mesa-good.url = "github:nixos/nixpkgs?ref=599ddd2b79331c1e6153e1659bdaab65d62c4c82";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";
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

        schweren = nixpkgs.lib.nixosSystem rec {
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
