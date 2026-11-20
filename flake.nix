{
  description = "Torben's machines";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=staging";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=staging-nixos";
    #nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable-small";
    #nixpkgs.url = "path:/home/torben/Nextcloud/Programmierung/NixOS/nixpkgs"; # local

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-alien.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    # vscode-server does not have nixpkgs input defined

    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";

    opendeck-nix.url = "github:Kitt3120/opendeck-nix";
    # not setting the nixpkgs input for opendeck-nix to prevent hash mismatches
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
            inputs.nixos-hardware.nixosModules.framework-16-7040-amd
          ];
        };

        gensokyo = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit self system inputs; };
          modules = [
            ./configuration.nix
            ./_profiles/gensokyo.nix
            inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
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

        flipflop = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit self system inputs; };
          modules = [
            ./configuration.nix
            ./_profiles/flipflop.nix
            inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
          ];
        };
      };
    };
}
