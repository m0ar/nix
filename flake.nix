{
  description = "Home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self, home-manager, nixpkgs, utils,
    poetry2nix, nixos-hardware, fenix, nix-index-database
  }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
        overlays = [
          fenix.overlays.default
        ];
      };
      blep = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ ./machines/blep.nix ];
      };
    in {
      homeConfigurations = {
        m0ar = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix nix-index-database.homeModules.nix-index ];
          extraSpecialArgs = { inherit inputs; isNixOS = false; };
        };

        mediacenter = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
          };
          modules = [ ./machines/mediacenter.nix nix-index-database.homeModules.nix-index ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
      nixosConfigurations.blep = blep;
      nixosConfigurations.xin = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ./machines/xin.nix
          nixos-hardware.nixosModules.framework-13-7040-amd
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              users.m0ar.imports = [ ./home.nix nix-index-database.homeModules.nix-index ];
              extraSpecialArgs = {
                inherit inputs;
                isNixOS = true;
              };
              useUserPackages = true;
              useGlobalPkgs = true;
            };
          }
        ];
      };
      vms.blep = blep.config.system.build.vm;
    };
}
