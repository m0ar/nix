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
    kak-one = {
      url = "github:raiguard/kak-one";
      flake = false;
    };
    kak-rainbower = {
      url = "github:crizan/kak-rainbower";
      flake = false;
    };
  };

  outputs = {
    self, home-manager, nixgl, nixpkgs, utils,
    zshPure, kak-one, kak-rainbower, icetan-overlay
  }@flakeInputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ] ++ icetan-overlay.overlays.default;
      };
    in {
      homeConfigurations.m0ar = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
        extraSpecialArgs = { inputs = flakeInputs; };
      };
    };
}
