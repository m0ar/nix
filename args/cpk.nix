{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage {
  pname = "ceramic-pocket-knife";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "ceramicnetwork";
    repo = "ceramic-pocket-knife";
    rev = "17cdffc8a985a518c0c28379c78517f94b97e003";
    sha256 = "sha256-m41WVpdQE+TAaeiEp92EEcH+JZvN0Mak8JZolxAs/Do=";
  };

  cargoHash = "sha256-6YhYYQb2sCXzP3Rf9GAxLCHUMok2kkqzFbK33DjdVzs=";
  
  # meta = with stdenv.lib; {
  #   description = "CLI multitool for Ceramic IDs and data";
  #   homepage = "https://github.com/ceramicnetwork/ceramic-pocket-knife";
  #   license = licenses.MIT;
  # };
}
