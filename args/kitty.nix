{ pkgs, ... }: {
  enable = true;
  font = {
    package = pkgs.fira-code;
    name = "FiraCode";
    size = 12;
  };
  settings = {
    cursor_shape = "block";
    scrollback_lines = 20000;
    # confirm if more than one kitty window is open
    confirm_os_window_close = 2;
    enable_audio_bell = false;
  };
  keybindings = {
    "ctrl+shift+n" = "new_os_window_with_cwd";
    # Blocks helix bindings
    "ctrl+tab" = "no_op";
    "ctrl+shift+tab" = "no_op";
  };
  themeFile = "OneDark";
}
