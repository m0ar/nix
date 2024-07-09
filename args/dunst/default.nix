{ pkgs, ... }: {
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-nord;
    size = "32x32";
  };
  settings = {
    global = {
      offset = "100x100";
      font = "FiraCode 12";
      # frame_color = "#90648b";
    };

    urgency_low = {
      background = "#282A2E";
      foreground = "#6272a4";
      timeout = 10;
    };

    urgency_normal = {
      background = "#282A2E";
      foreground = "#bd93f9";
      timeout = 10;
    };
    
    urgency_critical = {
      background = "#282A2E";
      foreground = "#f8f8f2";
      timeout = 10;
    };
  };
}
