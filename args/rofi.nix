{ pkgs, ... }: {
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
    modi = "drun,calc,combi";
    combi-modi = "systemd,emoji";
  };
  theme = "Monokai";
}
