{ zsh }:
{
  enable = true;
  settings = {
    env = {
      TERM = "xterm-256color";
    };
    
    font = let fam = { family = "FiraCode Nerd Font"; }; in {

      normal = fam // { style = "Regular"; };
      bold = fam // { style = "Bold"; };
      italic = fam // { style = "Italic"; };
    };

    cursor = {
      style = "Block";
      unfocused_hollow = true;
    };

    shell = {
      program = "${zsh}/bin/zsh";
    };
  };
}
