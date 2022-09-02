# Inspo: https://github.com/jonringer/nixpkgs-config/blob/master/flake.nix
{
  description = "Home-manager configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, utils }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };

      # Workaround from https://github.com/nix-community/home-manager/issues/2848#issuecomment-1196005666
      laptop = self.homeConfigurations.laptop.activationPackage;
      apps.x86_64-linux.update-home = {
        type = "app";
        program = (nixpkgs.legacyPackages.x86_64-linux.writeScript "update-home" ''
          set -euo pipefail
          old_profile=$(${nixpkgs.legacyPackages.x86_64-linux.nix}/bin/nix profile list | grep home-manager-path | head -n1 | awk '{print $4}')
          echo $old_profile
          ${nixpkgs.legacyPackages.x86_64-linux.nix}/bin/nix profile remove $old_profile
          ${self.laptop}/activate || (echo "restoring old profile"; ${nixpkgs.legacyPackages.x86_64-linux.nix}/bin/nix profile install $old_profile)
        '').outPath;
      };
    };
}
