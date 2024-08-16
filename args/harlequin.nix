{ pkgs, poetry2nix, ... }:

poetry2nix.mkPoetryApplication rec {
  pname = "harlequin";
  version = "1.23.1";  # Replace with the actual version

  projectDir = pkgs.fetchFromGitHub {
    owner = "tconbeer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AVRhBRsUDt5qITRUhf/t0ACpliaj1dF8rlLETBVrfT4=";
  };

  preferWheels = true;

  overrides = poetry2nix.overrides.withDefaults (final: prev: {
    mysql-connector-python = prev.mysql-connector-python.overridePythonAttrs (
      old: {
        nativeBuildInputs = [ pkgs.openssl ];
      }
    );
  });
  doCheck = false;  # Disable tests if they're causing issues
}
