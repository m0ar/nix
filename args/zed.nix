{ ... }:
{
  enable = true;
  extensions = [
    "nix"
    "terraform"
    "sql"
  ];
  userSettings = {
    theme = {
      mode = "dark";
      dark = "One Dark";
    };
    helix_mode = true;
    buffer_font_family = "Fira Code";
    buffer_font_size = 18;
    ui_font_family = "Fira Code";
    ui_font_size = 18;
    format_on_save = "on";
    hour_format = "hour24";
  };
}
