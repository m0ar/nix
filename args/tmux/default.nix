{ ... }:
{
  enable = true;
  clock24 = true;
  escapeTime = 0;
  historyLimit = 50000;
  prefix = "C-Space";
  terminal = "screen-256color";
  extraConfig = builtins.readFile ./tmux.conf;
}
