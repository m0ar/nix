{ 
  isNixOS ? false,
  ...
}:
let
  # Should probably check the configuration name instead
  devices = if isNixOS
    then { battery = "BAT1"; adapter = "ACAD"; }
    else { battery = "BAT0"; adapter = "ADP1"; };
in
{
  enable = true;
  script = "polybar top &";
  settings = rec {
    colors = {
      background = "#000000";
      background-alt = "#373B41";
      foreground = "#ABB2BF";
      muted = "#585858";
      urgent = "#E06C75";
      primary = "#D19A66";
      accent = "#90648B";
      # background = "#282A2E";
      # foreground = "#C5C8C6";
      # primary = "#F0C674";
      # secondary = "#8ABEB7";
      # alert = "#A54242";
      # disabled = "#707880";
    };
    "bar/top" = {
      width = "100%";
      height = "2%";
      radius = 0;
      background = colors.background;
      foreground = colors.foreground;
      line.size = "3pt";
      border = {
        size = "0pt";
        color = "#00000000";
      };
      padding = {
        left = 0;
        right = 1;
      };

      module.margin = 1;
      separator = "|";

      "font-0" = "Fira Code:size=10;2";
      "font-1" = "Noto Color Emoji:scale=13;2";
      "font-2" = "Symbols Nerd Font Mono:size=10;2";
      "font-3" = "FontAwesome:size=10;2";

      modules = {
        left = "xworkspaces xwindow";
        center = "date";
        right = "filesystem memory cpu wlan eth battery tray";
      };

      cursor = {
        click = "pointer";
        scroll = "ns-resize";
      };

      enable.ipc = true;
    };

    "module/tray" = {
      type = "internal/tray";
      # format = {
          # margin = "10px";
      # };
      tray = {
        spacing = "5px";
        size = "50%";
      };
    };

    "module/xworkspaces" = {
      type = "internal/xworkspaces";
      label = {
        active = "%name%";
        active-background = colors.background-alt;
        # active-underline = colors.primary;
        active-padding = 1;

        occupied = "%name%";
        occupied-padding = 1;

        urgent = "%name%";
        urgent-background = colors.urgent;
        urgent-padding = 1;
      };
    };

    "module/xwindow" = {
      type = "internal/xwindow";
      label = "%title:0:60:...%";
    };

    "module/filesystem" = {
      type = "internal/fs";
      interval = 25;
      "mount-0" = "/";
      label = {
        mounted = "%{F${colors.primary}}%mountpoint%%{F-} %percentage_used%%";
      };
    };

    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      warn-percentage = 50;
      label = "%{F${colors.primary}}RAM%{F-} %percentage_used:2%%";
      label-warn = "%{F${colors.urgent}}RAM%{F-} %percentage_used:2%%";
    };

    "module/cpu" = {
      type = "internal/cpu";
      interval = 2;
      format = {
        prefix = "CPU ";
        prefix-foreground = colors.primary;
      };
      label = "%percentage:2%%";
    };

    "network-base" = {
      type = "internal/network";
      interval = 5;
      format = {
        connected = "<label-connected>";
        disconnected = "<label-disconnected>";
      };
    };

    "module/wlan" = {
      "inherit" = "network-base";
      interface.type = "wireless";
      label.connected = "%{F${colors.primary}}wlan%{F-} %essid%";
      label.disconnected =
        "%{F${colors.primary}}wlan%{F-} disconnected";
    };

    "module/eth" = {
      "inherit" = "network-base";
      interface.type = "wired";
      label.connected = "%{F${colors.primary}}eth%{F-} %local_ip%";
    };

    "module/date" = {
      type = "internal/date";
      interval = 5;
      date = "%d.%m.%y";
      time = "%H:%M";
      label = "%time%  %date%";
    };

    "module/battery" = {
      type = "internal/battery";
      battery = devices.battery;
      adapter = devices.adapter;

      full.at = if isNixOS then 99 else 90;
      low.at = 15;
      poll.interval = 5;

      time.format = "%H:%M";

      format = {
        charging = "<label-charging>";
        discharging = "<ramp-capacity> <label-discharging>";
        low = "<animation-low> <label-low>";
      };

      label = {
        charging = "Charging %percentage%%";
        discharging = "%{F${colors.primary}}Discharging%{F-} %percentage%%";
        full = "Fully charged";
        low = "%{F${colors.urgent}}Discharging%{F-} %percentage%%";
      };

      ramp.capacity = {
        "0" = "";
        "1" = "";
        "2" = "";
        "3" = "";
        "4" = "";
      };

      # Only applies if <bar-capacity> is used
      bar.capacity.width = 10;

      animation = {
        charging = {
          "0" = "";
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          framerate = 750;
        };
        
        discharging = {
          "0" = "";
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          framerate = 500;
        };

        low = {
          "0" = "%{F${colors.urgent}}%{F-}";
          "1" = "  ";
          framerate = 500;
        };
      };
    };

    settings = {
      screenchange.reload = true;
      psuedo-transparency = true;
    };
  };
}
