{ pkgs
, config
, scripts
, ...
}:
let
  pavol = "${scripts.pavol}/bin/pavol";
  pixlock = "${scripts.pixlock}/bin/pixlock";
  firaCode = {
    names = [ "Fira Code" ];
    style = "Regular";
    size = 6.0;
  };
  topBar = {
    command = "i3bar";
    statusCommand = "${pkgs.i3status}/bin/i3status";
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
    m1 = "DP-1-3";
    m2 = "DP-1-2";
  };
in {
  conf = {
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
        "1" = [{ class = "Google-chrome"; } { class = "firefox"; } ];
        "3" = [{ class = "Code"; }];
        "6" = [{ class = "Slack"; }];
        "8" = [{ class = "obsidian"; }];
      };
      window = {
        commands = [
          {
            criteria = { class = "Spotify"; };
            command = "move container to workspace 9";
          }
        ];
        border = 3;
        hideEdgeBorders = "smart";
        titlebar = false;
      };
      modifier = "Mod4";
      bars = []; # Polybar as systemd user service
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
          { class = "flameshot"; }
        ];
      };
      keybindings = with pkgs;
        lib.mkOptionDefault {
          "${modifier}+Return" =
            "exec ${nixgl.nixGLIntel}/bin/nixGLIntel ${kitty}/bin/kitty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+Ctrl+m" = "exec pavucontrol";
          "XF86AudioRaiseVolume" = "exec ${pavol} 5";
          "XF86AudioLowerVolume" = "exec ${pavol} -5";
          "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "Print" = "exec ${nixgl.nixGLIntel}/bin/nixGLIntel flameshot gui";
          "--release ${modifier}+Shift+Return" =
            "exec ${pixlock} --no-unlock-indicator";
          "--release ${modifier}+space" =
            "exec ${config.programs.rofi.finalPackage}/bin/rofi -show drun";
        };
      startup = with pkgs;
        builtins.map (as: as // { notification = false; }) [
          {
            command = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
          }
          { command = "xfce4-power-manager"; }
          { command = "slack"; }
          { command = "firefox"; }
          # { command = "google-chrome-stable"; }
          { command = "obsidian"; }
          { command = "spotify"; }
          { command = "${xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${pixlock} --nofork --no-unlock-indicator"; }
        ];
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 0;
        outer = 0;
      };
    };
    extraConfig = ''
      default_border pixel 2
      default_floating_border normal
      hide_edge_borders none
    '';
  };
}
