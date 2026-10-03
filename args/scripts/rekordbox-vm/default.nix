{ pkgs, ... }:
let
  autounattendIso = pkgs.runCommand "autounattend.iso"
    { nativeBuildInputs = [ pkgs.xorriso ]; }
    ''
      mkdir staging
      cp ${./autounattend.xml} staging/autounattend.xml
      xorriso -as mkisofs -J -r -o $out staging/
    '';

  _rekordbox-vm = pkgs.writeShellScriptBin "_rekordbox-vm"
    (builtins.readFile ./rekordbox-vm.sh);
in
pkgs.writeShellScriptBin "rekordbox-vm" ''
  AUTOUNATTEND_ISO=${autounattendIso} ${_rekordbox-vm}/bin/_rekordbox-vm "$@"
''
