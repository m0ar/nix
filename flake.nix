{
  description = "Home-manager configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    icetan-overlay.url = "github:icetan/nixpkgs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl.url = "github:guibou/nixGL";
    zshPure = {
      url = "github:sindresorhus/pure";
      flake = false;
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self, home-manager, nixgl, nixpkgs, utils,
    zshPure, icetan-overlay, poetry2nix, nixos-hardware
  }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
        overlays = [ nixgl.overlay ] ++ icetan-overlay.overlays.default;
      };
      server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [ ./server.nix ];
      };
    in {
      homeConfigurations = {
        m0ar = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = { inherit inputs; };
        };

        osmc = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
          };
          modules = [ ./osmc.nix ];
          extraSpecialArgs = { inherit inputs; };
        };
      };
      nixosConfigurations.blep = server;
      nixosConfigurations.xin = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        specialArgs = { inherit inputs; };
        modules = [
          ./xin.nix
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
      vms.blep = server.config.system.build.vm;
    };
}
