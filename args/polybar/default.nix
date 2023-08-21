{ ... }:
{
  enable = true;
  script = "polybar top &";
  settings = rec {
    colors = {
      background = "#282A2E";
      background-alt = "#373B41";
      foreground = "#C5C8C6";
      primary = "#F0C674";
      secondary = "#8ABEB7";
      alert = "#A54242";
      disabled = "#707880";
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

      "font-0" = "FiraCode:size=10;3";
      "font-1" = "FontAwesome:size=10;3";

      modules = {
        left = "xworkspaces xwindow";
        center = "date";
        right = "filesystem pulseaudio memory cpu wlan eth battery";
      };

      cursor = {
        click = "pointer";
        scroll = "ns-resize";
      };

      enable.ipc = true;
      tray.position = "right";
    };

    "module/xworkspaces" = {
      type = "internal/xworkspaces";
      label = {
        active = "%name%";
        active-background = colors.background-alt;
        active-underline = colors.primary;
        active-padding = 1;

        occupied = "%name%";
        occupied-padding = 1;

        urgent = "%name%";
        urgent-background = colors.alert;
        urgent-padding = 1;

        empty = "%name%";
        empty-foreground = colors.disabled;
        empty-padding = 1;
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
        mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";
        unmounted = "%mountpoint% not mounted";
        "unmounted-foreground" = colors.disabled;
      };
    };

    "module/pulseaudio" = rec {
      type = "internal/pulseaudio";

      format = {
        volume-prefix = "VOL ";
        volume-prefix-foreground = colors.primary;
        volume = label.volume;
      };

      label = {
        volume = "%percentage%%";
        muted = "muted";
        muted-foreground = colors.disabled;
      };
    };

    "module/memory" = {
      type = "internal/memory";
      interval = 2;
      format = {
        prefix = "RAM ";
        prefix-foreground = colors.primary;
      };
      label = "%percentage_used:2%%";
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

    "network-base" = rec {
      type = "internal/network";
      interval = 5;
      format = {
        connected = "<label-connected>";
        disconnected = label.disconnected;
      };
      label.disconnected =
        "%{F${colors.primary}}%ifname%%{F-} disconnected";
    };

    "module/wlan" = {
      "inherit" = "network-base";
      interface.type = "wireless";
      label.connected = "%{F${colors.primary}}%ifname%%{F-} %essid%";
    };

    "module/eth" = {
      "inherit" = "network-base";
      interface.type = "wired";
      label.connected = "%{F${colors.primary}}%ifname%%{F-} %local_ip%";
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
      battery = "BAT0";
      adapter = "ADP1";
      full.at = 98;
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
        low = "%{F${colors.alert}}Discharging%{F-} %percentage%%";
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
          "0" = "%{F${colors.alert}}%{F-}";
          "1" = " ";
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
