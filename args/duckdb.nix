{ pkgs }:

# Requires a cert at /etc/ssl/cert.pem:
#
# sudo ln -sf /etc/ssl/certs/ca-bundle.crt /etc/ssl/cert.pem

pkgs.stdenv.mkDerivation rec {
  pname = "duckdb";
  version = "1.2.1";
  src = pkgs.fetchzip {
    url = "https://github.com/duckdb/duckdb/releases/download/v${version}/duckdb_cli-linux-amd64.zip";
    hash = "sha256-lriOKgvTLgrJNjjS6gnY90fJ303jAVKnnWprAkNzLg8=";
  };
  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
  ];
  buildInputs = with pkgs; [
    libcxx
    libgcc
    openssl
  ];
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    install -m755 -D source/duckdb $out/bin/duckdb
    runHook postInstall
  '';
}
