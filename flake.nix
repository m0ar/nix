{
  description = "Home-manager configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    poetry2nix, nixos-hardware, fenix
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
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };

        mediacenter = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
          };
          modules = [ ./machines/mediacenter.nix ];
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
              users.m0ar.imports = [ ./home.nix ];
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
