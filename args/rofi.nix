{ pkgs, ... }: {
  enable = true;
  terminal = "${pkgs.kitty}/bin/kitty";
  font = "Fira Code 14";
  plugins = with pkgs; [
    rofi-calc
    rofi-systemd
    rofi-emoji
    rofi-power-menu
  ];
  pass = {
    enable = true;
    extraConfig = "";
    stores = [];
  };
  extraConfig = {
    show = "combi";
    combi-modes = "window,drun,run";
    modes = "combi,emoji,calc";
  };
  theme = "Monokai";
}
