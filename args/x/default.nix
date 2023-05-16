{ i3, pkgs, lib, ... }:
{
  session = {
    enable = true;
    windowManager = {
      command = lib.mkForce "${pkgs.i3-gaps}/bin/i3 -V -d all &>> /home/m0ar/i3.log";
      i3 = i3.conf;
    };
    profileExtra = builtins.readFile ./xprofile;
  };

  configFiles = {
    ".xinitrc".source = ./xinitrc;
    ".Xmodmap".source = ./xmodmap;
    ".Xmodmap_split".source = ./xmodmap_split;
  };
}
