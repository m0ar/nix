{ pkgs }: {
  enable = true;
  terminal = "${pkgs.kitty}/bin/kitty";
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
    modi = "drun,combi";
    combi-modi = "systemd,calc,emoji";
  };
  theme = "Monokai";
}
