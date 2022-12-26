{ pkgs, ... }:
let
  inherit (pkgs) lib;
  rcFiles = builtins.attrNames (builtins.readDir ./rc);
  rcPaths = builtins.map (f: ./. + "/rc/${f}") rcFiles;
in {
  enable = true;
  plugins = with pkgs.kakounePlugins; [
    kak-lsp
    kak-fzf
  ];
  config = {
    autoReload = "yes";
    colorScheme = "pastel";
    incrementalSearch = true;
    showMatching = true;
    indentWidth = 2;
    tabStop = 2;
    ui = {
      assistant = "clippy";
      enableMouse = true;
    };
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
    #hooks = [];
  };
  extraConfig = ''
	hook global ModuleLoaded fzf-grep %{
  	set-option global fzf_grep_command 'rg'
	}

  add-highlighter /global regex ^[^\n]{80}([^\n]) 1:+r

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

  ${lib.concatMapStringsSep "\n\n" builtins.readFile rcPaths}
  '';

  xdgConfigs = {
    "kak-lsp/kak-lsp.toml".text = (import ./kak-lsp-toml.nix pkgs);
  };
}
