{ fontPkg }:
{
  enable = true;
  environment = {
    TERM = "xterm-256color";
  };
  font = {
    package = fontPkg;
    name = "FiraCode";
    size = 12;
  };
  settings = {
    cursor_shape = "block";
    scrollback_lines = 20000;
  };
}
