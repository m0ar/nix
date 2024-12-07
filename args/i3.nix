{ pkgs
, config
, scripts
, ...
}:
let
  pavol = "${scripts.pavol}/bin/pavol";
  pixlock = "${scripts.pixlock}/bin/pixlock";
  xbacklight = "${pkgs.acpilight}/bin/xbacklight";
  firaCode = {
    names = [ "Fira Code" ];
    style = "Regular";
    size = 6.0;
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
        "1" = [{ class = "Brave-browser"; }];
        # "3" = [{ class = "Code"; }];
        # "6" = [{ class = "Slack"; }];
        # "8" = [{ class = "obsidian"; }];
      };
      window = {
        commands = [
          {
            criteria = { class = "Spotify"; };
            command = "move container to workspace 9";
          }
        ];
        border = 3;
        hideEdgeBorders = "both";
        titlebar = false;
      };
      modifier = "Mod4";
      bars = []; # Polybar as systemd user service
      colors = colorConfig;
      focus = { followMouse = true; };
      fonts = firaCode;
      floating = {
        criteria = [
          { title = "i3_help"; }
          { class = "Lxappearance"; }
          { class = "Pavucontrol"; }
          { class = "Blueman-manager"; }
          { class = "flameshot"; }
          { class = "zoom"; }
          { class = "system-config-printer"; }
          { window_role = "pop-up"; }
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
          "XF86MonBrightnessUp" = "exec ${xbacklight} -inc 5";
          "XF86MonBrightnessDown" = "exec ${xbacklight} -dec 5";
          "Print" = "exec ${nixgl.nixGLIntel}/bin/nixGLIntel flameshot gui";
          "--release ${modifier}+Shift+Return" = "exec ${pixlock}";
          "--release ${modifier}+space" =
            "exec ${config.programs.rofi.finalPackage}/bin/rofi -show combi";
        };
      startup =
        builtins.map (as: as // { notification = false; }) [
          {
            # Clear logfile on restart
            command = "echo '' > ~/i3.log";
            always = true;
          }
          {
            command = "systemctl --user restart polybar";
            always = true;
          }
          {
            command = "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
          }
          { command = "brave"; }
          # { command = "obsidian"; }
          # { command = "spotify"; }
          { command = "xss-lock --transfer-sleep-lock -- ${pixlock} --nofork"; }
          { command = "blueman-applet"; }
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
      workspace_auto_back_and_forth yes
    '';
  };
}
