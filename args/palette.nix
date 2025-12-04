# Shared color palettes
rec {
  default = onedark;

  onedark = {
    # Core ANSI colors
    black   = "#21252B";
    red     = "#E06C75";
    green   = "#98C379";
    yellow  = "#E5C07B";
    blue    = "#61AFEF";
    purple  = "#C678DD";
    cyan    = "#56B6C2";
    white   = "#ABB2BF";

    # Bright variants (ANSI 8-15)
    brightBlack  = "#767676";
    brightRed    = "#E06C75";
    brightGreen  = "#98C379";
    brightYellow = "#E5C07B";
    brightBlue   = "#61AFEF";
    brightPurple = "#C678DD";
    brightCyan   = "#56B6C2";
    brightWhite  = "#ABB2BF";

    # Extended palette for UI elements
    gold       = "#D19A66";
    lightBlack = "#2C313A";
    gray       = "#3E4452";
    faintGray  = "#323844";
    lightGray  = "#5C6370";
    linenr     = "#4B5263";

    # Semantic aliases
    background = "#21252B";
    foreground = "#ABB2BF";
    selection  = "#323844";
    cursor     = "#ABB2BF";
  };
}
