{ stdenv, ... }:
stdenv.mkDerivation rec {
  name = "desci-cli";
  version = "0.0.1";
  src = ./src;
  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin
    cp --recursive ${src}/* $out/bin
    chmod +x --recursive $out/bin
  '';
}
