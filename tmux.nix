{
  enable = true;
  clock24 = true;
  escapeTime = 0;
  historyLimit = 50000;
  prefix = "C-Space";
  terminal = "screen-256color";
  extraConfig = ''
    set -g mouse on
    unbind C-b

    # Quick window switching
    unbind a
    bind a last-window
    bind C-space next-window

    # Nav
    bind -n C-h select-pane -L
    bind -n C-j select-pane -D
    bind -n C-k select-pane -U
    bind -n C-l select-pane -R
    bind k resize-pane -U 10
    bind j resize-pane -D 10
    bind h resize-pane -L 20
    bind l resize-pane -R 20

    # Window title
    set -g set-titles on
    set -g set-titles-string "[#{session_name}] #{window_index}:#{window_name} - #{pane_title}"

    # Longer info
    set -g display-time 4000

    setw -g mode-keys vi
    bind-key -T copy-mode-vi 'v' send -X begin-selection
    bind-key -T copy-mode-vi 'V' send -X select-line
    bind-key -T copy-mode-vi 'y' send -X copy-pipe-and-cancel "xsel -ib"
    bind-key -T copy-mode-vi 'C-v' send -X rectangle-toggle
    # Bind ']' to use pbpaste
    unbind ]
    bind ] run "xsel -ob | tmux load-buffer - ; tmux paste-buffer"
  '';
}
