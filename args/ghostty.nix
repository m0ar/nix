{ palette, ... }:
let
  colors = palette.default;
in {
  enable = true;
  enableBashIntegration = true;
  enableZshIntegration = true;
  installBatSyntax = true;
  systemd.enable = true;
  settings = {
    window-decoration = "server";
    font-family = "Fira Code";
    shell-integration-features = "ssh-terminfo,ssh-env";

    # Colors from shared palette
    background = colors.background;
    foreground = colors.foreground;
    cursor-color = colors.cursor;
    selection-background = colors.selection;
    selection-foreground = colors.foreground;

    # ANSI colors 0-15
    palette = [
      "0=${colors.black}"
      "1=${colors.red}"
      "2=${colors.green}"
      "3=${colors.yellow}"
      "4=${colors.blue}"
      "5=${colors.purple}"
      "6=${colors.cyan}"
      "7=${colors.white}"
      "8=${colors.brightBlack}"
      "9=${colors.brightRed}"
      "10=${colors.brightGreen}"
      "11=${colors.brightYellow}"
      "12=${colors.brightBlue}"
      "13=${colors.brightPurple}"
      "14=${colors.brightCyan}"
      "15=${colors.brightWhite}"
    ];
  };
}
