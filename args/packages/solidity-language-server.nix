{ stdenv
, fetchFromGitHub
, buildNpmPackage
, lib
}:
buildNpmPackage rec {
  pname = "solidity-language-server";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "NomicFoundation";
    repo = "hardhat-vscode";
    rev = "v${version}";
    sha256 = "HURjmBaL5y8SZqqpFa4f7a2vVciFnAirYaaJU3m6mJ0=";
  };

  npmDepsHash = "sha256-XxmHiPp7Uu4JOMgEfnMKGWbXnzqMgAL5cFYCgTkc0SY=";

  # sourceRoot = "source/server";
  # postPatch = ''
  #   # There is one lockfile for the monorepo
  #   cp ${src}/package-lock.json .
  # '';
  
  meta = with lib; {
    description = "Solidity language server by Nomic Foundation";
    homepage = "https://github.com/NomicFoundation/hardhat-vscode";
    license = licenses.mit;
  };
} 
