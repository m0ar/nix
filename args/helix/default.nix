{ pkgs
, ... 
}:
{
  program = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        cursorline = true;
        auto-save = false;
        completion-replace = true;
        color-modes = true;
        bufferline = "multiple";
        smart-tab.enable = true;
        soft-wrap = {
          enable = true;
        };
        statusline = {
          left = [ 
            "mode"
            "spinner"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [
            "workspace-diagnostics"
            "version-control"
          ];
          right = [
            "diagnostics"
            "selections"
            "register"
            "position"
            "file-encoding"
          ];
        };
        indent-guides = {
          render = true;
        };
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          "\"" = "\"";
          "`" = "`";
          "'" = "'";
          "<" = ">";
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        }; 
        lsp = {
          display-messages = true;
          display-inlay-hints = false;
        };
        file-picker = {
          hidden = false;
        };
      };
    };
  };

  languageServers = with pkgs; [
    elixir_ls
    gopls
    marksman
    terraform-ls
    nil
    shellcheck
    kotlin-language-server
    elmPackages.elm-language-server
    python311Packages.python-lsp-server
  ] ++ (with nodePackages; [
    typescript-language-server
    vscode-json-languageserver-bin
    bash-language-server
    yaml-language-server
    dockerfile-language-server-nodejs
  ]);
}
