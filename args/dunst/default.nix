{ pkgs, ... }: {
  enable = true;
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-nord;
    size = "32x32";
  };
  settings = {
    global = {
      offset = "50x50";
      font = "FiraCode 12";
      # frame_color = "#90648b";
    };

    urgency_low = {
      background = "#282A2E";
      foreground = "#6272a4";
      timeout = 5;
    };

    urgency_normal = {
      background = "#282A2E";
      foreground = "#bd93f9";
      timeout = 5;
    };
    
    urgency_critical = {
      background = "#282A2E";
      foreground = "#f8f8f2";
      timeout = 5;
    };
  };
}
