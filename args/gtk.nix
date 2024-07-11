{ pkgs, ... }:
{
  enable = true;
  theme = {
    name = "Dracula";
    package = pkgs.dracula-theme;
  };
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-nord;
  };
}
