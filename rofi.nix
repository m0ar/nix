{ pkgs }:
{
  enable = true;
  terminal = "${pkgs.kitty}/bin/kitty";
  plugins = with pkgs; [
    rofi-calc
    rofi-systemd
    rofi-emoji
    rofi-power-menu
  ];
  extraConfig = {
    modi = "drun,calc,emoji,combi";
    combi-modi = "drun,calc,emoji";
  };
  theme = "Monokai";
}
