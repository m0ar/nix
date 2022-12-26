{ i3, pkgs, ... }:
{
  session = {
    enable = true;
    windowManager = {
      command = "${pkgs.i3-gaps}/bin/i3";
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
