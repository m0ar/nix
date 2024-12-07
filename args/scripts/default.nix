{ pkgs
, ...
}@args:
{
  pavol = pkgs.writeShellScriptBin "pavol" (builtins.readFile ./pavol.sh);
  colors = pkgs.writeShellScriptBin "colors" (builtins.readFile ./colors.sh);
  monitors = pkgs.writeShellScriptBin "monitors" (builtins.readFile ./monitors.sh);
  showkeys = pkgs.writeShellScriptBin "showkeys" (builtins.readFile ./showkeys.sh);
  pixlock = import ./pixlock args;
  desci = pkgs.callPackage ./desci args;
}
