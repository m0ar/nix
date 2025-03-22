{ pkgs, ... }:
{
  enable = true;
  package = pkgs.brave;
  extensions = [
    { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
  ];
}
