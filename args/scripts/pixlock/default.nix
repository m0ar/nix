{ pkgs
, ...
}:
let
  _pixlock = pkgs.writeShellScriptBin "_pixlock" (builtins.readFile ./pixlock.sh);
in
# Wrap, always setting icon
pkgs.writeShellScriptBin "pixlock" ''
  LOCK_ICON=${./lock.png} ${_pixlock}/bin/_pixlock "$@"
''

