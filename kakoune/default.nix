{ pkgs }: with pkgs.kakounePlugins; {
  enable = true;
  plugins = [
    kak-lsp
    kak-fzf
    kak-auto-pairs
    # kak-prelude
    # connect-kak
  ];
  config = {
    autoReload = "yes";
    colorScheme = "pastel";
    incrementalSearch = true;
    showMatching = true;
    indentWidth = 2;
    tabStop = 2;
    numberLines = {
      enable = true;
      highlightCursor = true;
      relative = true;
    };
    scrollOff = {
      columns = 5;
      lines = 5;
    };
    keyMappings = [
      {
        docstring = "fzf mode";
        effect = ": fzf-mode<ret>";
        key = "f";
        mode = "user";
      }{
        effect = ":comment-line<ret>";
        key = "'#'";
        mode = "global";
      }{
        docstring = "lsp mode";
        key = "l";
        mode = "user";
        effect = ":enter-user-mode lsp<ret>";
      }{
        docstring = "Copy";
        key = "y";
        mode = "user";
        effect = "<a-|>xclip -i -selection clipboard<ret>";
      }{
        docstring = "Cut";
        key = "d";
        mode = "user";
        effect = "<a-|>xclip -i -selection clipboard<ret>";
      }{
        docstring = "Paste (before)";
        key = "p";
        mode = "user";
        effect = "!xclip -i -selection clipboard -o<ret>";
      }{
        docstring = "Paste (after)";
        key = "P";
        mode = "user";
        effect = "!<a-!>xclip -i -selection clipboard -o<ret>";
      }{
        docstring = "Replace";
        key = "R";
        mode = "user";
        effect = "|xclip -out -selection clipboard<ret>";
      }
    ];
    # Global hooks
    hooks = [];
  };
  extraConfig = ''
    hook global BufCreate /.* %{
      # Autosave
      hook buffer NormalIdle .* %{
        try %{
          eval %sh{ [ "$kak_modified" = false ] && printf 'fail' }
          write
        }
      }
      add-highlighter buffer/trailing-ws regex '\h+$' 0:red
    }

    hook global InsertChar \t %{
      exec -draft h@
    }

    # Switch cursor color in insert mode
    set-face global InsertCursor default,red+B

    hook global ModeChange .*:.*:insert %{
        set-face window PrimaryCursor InsertCursor
        set-face window PrimaryCursorEol InsertCursor
    }

    hook global ModeChange .*:insert:.* %{
      try %{
        unset-face window PrimaryCursor
        unset-face window PrimaryCursorEol
      }
    }
    ## Git diff stuff
    # enable flag-lines hl for git diff
    hook global WinCreate .* %{
        add-highlighter window/git-diff flag-lines Default git_diff_flags
    }
    # trigger update diff if inside git dir
    hook global BufOpenFile .* %{
      evaluate-commands -draft %sh{
        cd $(dirname "$kak_buffile")
        if [ $(git rev-parse --git-dir 2>/dev/null) ]; then
          for hook in WinCreate BufReload BufWritePost; do
            printf "hook buffer -group git-update-diff %s .* 'git update-diff'\n" "$hook"
          done
        fi
      }
    }

    # LSPs
    eval %sh{kak-lsp --kakoune -s $kak_session}
    hook global WinSetOption filetype=(python|go|javascript|typescript|sh|elm|yaml|kak|elixir|nix|terraform) %{
      lsp-enable-window
      # lsp-inlay-diagnostics-enable window
      map -docstring "Show hover info" global user h ': lsp-hover<ret>'
    }

    hook global BufCreate .*/?PKGBUILD %{
        set-option buffer filetype sh
    }
  '';

}
