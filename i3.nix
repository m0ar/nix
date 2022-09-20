{ lib, pkgs, config }:
let
  firaCode = {
    names = [ "Fira Code" ];
    style = "Regular";
    size = 11.0;
  };
  topBar = {
    command = "i3bar";
    statusCommand = "i3status";
    position = "bottom";
    workspaceNumbers = null;
    fonts = firaCode;
    colors = {
      background = "#222D31";
      separator = "#454947";
      focusedWorkspace = {
        border = "#90648b";
        background = "#90648B";
        text = "#292F34";
      };
      activeWorkspace = {
        border = "#595B5B";
        background = "#353836";
        text = "#FDF6E3";
      };
      inactiveWorkspace = {
        border = "#595B5B";
        background = "#222D31";
        text = "#EEE8D5";
      };
      bindingMode = {
        border = "#16A085";
        background = "#2C2C2C";
        text = "#F9FAF9";
      };
      urgentWorkspace = {
        border = "#16A085";
        background = "#FDF6E3";
        text = "#E5201D";
      };
    };
  };
  colorConfig = {
    background = "#2B2C2B";
    focused = {
      border = "#90648B";
      background = "#556064";
      text = "#80FFF9";
      indicator = "#FDF6E3";
      childBorder = "#90648B";
    };
    focusedInactive = {
      border = "#2F3D44";
      background = "#2F3D44";
      text = "#1ABC9C";
      indicator = "#1ABC9C";
      childBorder = "#90648B";
    };
    unfocused = {
      border = "#2F3D44";
      background = "#2F3D44";
      text = "#1ABC9C";
      indicator = "#1ABC9C";
      childBorder = "#90648B";
    };
    urgent = {
      border = "#CB4B16";
      background = "#FDF6E3";
      text = "#1ABC9C";
      indicator = "#268BD2";
      childBorder = "#90648B";
    };
    placeholder = {
      border = "#000000";
      background = "#0c0c0c";
      text = "#ffffff";
      indicator = "#000000";
      childBorder = "#90648B";
    };
  };
  ws = {
    "1" = "1";
    "2" = "2";
    "3" = "3";
    "4" = "4";
    "5" = "5";
    "6" = "6";
    "7" = "7";
    "8" = "8";
    "9" = "9";
  };
  outputs = {
    m1 = "DP-3-8";
    m2 = "DP-3-1";
  };
in {
  enable = true;
  config = rec {
    workspaceOutputAssign = [
      {
        workspace = ws."1";
        output = outputs.m2;
      }
      {
        workspace = ws."2";
        output = outputs.m2;
      }
      {
        workspace = ws."3";
        output = outputs.m2;
      }
      {
        workspace = ws."4";
        output = outputs.m2;
      }
      {
        workspace = ws."5";
        output = outputs.m2;
      }
      {
        workspace = ws."6";
        output = outputs.m1;
      }
      {
        workspace = ws."7";
        output = outputs.m1;
      }
      {
        workspace = ws."8";
        output = outputs.m1;
      }
      {
        workspace = ws."9";
        output = outputs.m1;
      }
    ];
    assigns = {
      "3" = [{ class = "Code"; }];
      "4" = [{ class = "firefox"; }];
      "6" = [{ class = "Slack"; }];
      "8" = [{ class = "obsidian"; }];
    };
    window = {
      commands = [
        {
          criteria = { class = "Spotify"; };
          command = "move container to workspace 9";
        }
        {
          criteria = { class = "google-chrome"; };
          command = "move container to workspace 1";
        }
      ];
      border = 3;
      hideEdgeBorders = "smart";
      titlebar = false;
    };
    modifier = "Mod4";
    bars = [ topBar ];
    colors = colorConfig;
    focus = { followMouse = true; };
    fonts = firaCode;
    floating = {
      criteria = [
        { title = "alsamixer"; }
        { title = "i3_help"; }
        { class = "Lxappearance"; }
        { class = "Manjaro Settings Manager"; }
        { class = "Pamac-manager"; }
        { class = "Pavucontrol"; }
        { class = "qt5ct"; }
        { class = "(?i)System-config-printer.py"; }
        { class = "Blueman-manager"; }
      ];
    };
    keybindings = lib.mkOptionDefault {
      "${modifier}+Return" =
        "exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.kitty}/bin/kitty";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+d" = "exec --no-startup-id dmenu_recency";
      "${modifier}+z" = "exec --no-startup-id morc-menu";
      "${modifier}+Ctrl+m" = "exec pavucontrol";
      "XF86AudioPlay" = "exec --no-startup-id 'playerctl play-pause'";
      "XF86AudioNext" = "exec --no-startup-id 'playerctl next'";
      "XF86AudioPrev" = "exec --no-startup-id 'playerctl previous'";
      "Print" = "exec --no-startup-id i3-scrot";
      "${modifier}+Print" = "exec --no-startup-id i3-scrot -w";
      "--release ${modifier}+Shift+Print" = "exec --no-startup-id i3-scrot -s";
      "--release ${modifier}+Shift+Return" =
        "exec --no-startup-id /home/m0ar/scripts/lock.sh";
      "--release ${modifier}+space" =
        "exec --no-startup-id ${config.programs.rofi.finalPackage}/bin/rofi -show drun";
    };
    startup = builtins.map (as: as // { notification = false; }) [
      { command = "nm-applet"; }
      { command = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"; }
      { command = "xsetroot -solid '#000000'"; }
      { command = "xfce4-power-manager"; }
      { command = "blueman-applet"; }
      {
        command = "fix_xcursor";
        always = true;
      }
      { command = "xmodmap ~/.Xmodmap"; }
      { command = "slack"; }
      { command = "firefox"; }
      { command = "google-chrome-stable"; }
      { command = "obsidian"; }
      { command = "spotify"; }
      { command = "/home/m0ar/scripts/workspace-2.sh"; }
      { command = "systemctl --user start i3-session.target"; }
      { command = "pa-applet"; }
      { command = "playerctld daemon"; }
    ];
    gaps = {
      smartBorders = "on";
      smartGaps = true;
      inner = 0;
      outer = 0;
    };
  };
  extraConfig = ''
    default_border pixel 3
    default_floating_border normal
    hide_edge_borders none
  '';
}
