{ pkgs
, config
, ... 
}:
let
  languageServers = {
    inherit (pkgs) elixir_ls gopls marksman terraform-ls nil shellcheck kotlin-language-server rust-analyzer;
    elm-language-server = pkgs.elmPackages.elm-language-server;
    python-lsp-server = pkgs.python311Packages.python-lsp-server;
    inherit (pkgs.nodePackages) typescript-language-server vscode-langservers-extracted bash-language-server yaml-language-server dockerfile-language-server-nodejs eslint;
  };
  eslintRcNames = [ ".eslintrc" ".eslintrc.js" ".eslintrc.cjs" ".eslintrc.json" ];
in
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
        completion-replace = false;
        color-modes = true;
        bufferline = "always";
        # rulers = [ 80 100 ];
        smart-tab.enable = true;
        soft-wrap.enable = true;
        popup-border = "all";
        statusline = {
          separator = "|";
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
            "position-percentage"
            "total-line-numbers"
          ];
        };
        indent-guides = {
          render = true;
          character = "╎"; # Some characters that work well: "▏", "┆", "┊", "⸽"
          skip-levels = 1;
        };
        auto-pairs = {
          "(" = ")";
          "{" = "}";
          "[" = "]";
          # "<" = ">";
          # "\"" = "\"";
          # "`" = "`";
          # "'" = "'";
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
          git-ignore = true;
        };
        whitespace = {
          render = {
            tab = "all";
            nbsp = "all";
            space = "all";
            nnbsp = "all";
            tabpad = "all";
            newline = "none";
          };
          characters = {
            tab = "→";
            nbsp = "⍽";
            space = " ";
            nnbsp = "⍽";
            tabpad = "-";
            newline = "⏎";
          };
        };
      };
      keys = {
        normal = {
          X = "extend_line_above";
          D = [ "extend_to_line_end" "change_selection" ];
          C-tab = ":buffer-previous";
          C-S-tab = ":buffer-next";
          esc = [ "collapse_selection" "keep_primary_selection" ];
          tab = "goto_next_function";
          S-tab = "goto_prev_function";
          # Mark line and move up/down
          A-j = [
            "extend_to_line_bounds"
            "delete_selection"
            "paste_after"
          ];
          A-k = [
            "extend_to_line_bounds"
            "delete_selection"
            "move_line_up"
            "paste_before"
          ];
          # Duplicate lines up/down (also in insert)
          S-A-j = [
            "extend_to_line_bounds"
            "yank"
            "open_below"
            "normal_mode"
            "replace_with_yanked"
            "collapse_selection"
          ];
          S-A-k = [
            "extend_to_line_bounds"
            "yank"
            "open_above"
            "normal_mode"
            "replace_with_yanked"
            "collapse_selection"
          ];
        };
        insert = {
          A-tab = "completion";
          # Duplicate lines up/down (also in normal)
          S-A-j = [
            "normal_mode"
            "extend_to_line_bounds"
            "yank"
            "open_below"
            "normal_mode"
            "replace_with_yanked"
            "collapse_selection"
          ];
          S-A-k = [
            "normal_mode"
            "extend_to_line_bounds"
            "yank"
            "open_above"
            "normal_mode"
            "replace_with_yanked"
            "collapse_selection"
          ];
        };
      };
    };
    languages = if config.home.username == "osmc" then {} else {
      language = [
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" "eslint-lsp"];
          roots = [ "package-lock.json" "yarn.lock" ] ++ eslintRcNames;
        }
        {
          name = "tsx";
          language-servers = [ "typescript-language-server" "eslint-lsp"];
          roots = [ "package-lock.json" "yarn.lock" ] ++ eslintRcNames;
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" "eslint-lsp"];
          roots = [ "package-lock.json" "yarn.lock" ] ++ eslintRcNames;
        }
      ];
      language-server = {
        typescript-language-server = with languageServers; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
          config = {
            hostInfo = "helix";
            documentFormatting = false;
            completions = {
              completeFunctionCalls = true;
            };
            typescript.inlayHints = {
               includeInlayEnumMemberValueHints = true;
               includeInlayFunctionLikeReturnTypeHints = true;
               includeInlayFunctionParameterTypeHints = true;
               includeInlayParameterNameHints = "all";
               includeInlayParameterNameHintsWhenArgumentMatchesName = true;
               includeInlayPropertyDeclarationTypeHints = true;
               includeInlayVariableTypeHints = true;
              };
            };
            javascript.inlayHints = {
              includeInlayEnumMemberValueHints = true;
              includeInlayFunctionLikeReturnTypeHints = true;
              includeInlayFunctionParameterTypeHints = true;
              includeInlayParameterNameHints = "all";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = true;
              includeInlayVariableTypeHints = true;
            };
          };
          eslint-lsp = with languageServers; {
            command = "${vscode-langservers-extracted}/bin/eslint";
            args = [ "--stdio" ];
            required-root-patterns = [ "\.eslintrc(.*)?" ];
            config = {
              format = false;
              nodePath = "";
              onIgnoredFiles = "off";
              validate = "on";
              run = "onType";
              quiet = false;
              problems = { shortenToSingleLine = false; };
              # experimental = { useFlatConfig = false };
              rulesCustomizations = [];
              workingDirectory = {
                mode = "auto"; # alt. "location" ?
              };
              # useESLintClass = false; ?
              # packageManager = "npm" ?
              codeAction = { 
                disableRuleComment = { 
                  enable = true;
                  location = "separateLine";
                };
                showDocumentation.enable = true;
              };
            };
          };
        };
      };
    };
      # [[language]]
      #  name = "typescript"
      #  language-servers = [  "typescript-language-server", "tailwindcss-react", "eslint"]
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "typescript"] }
      #  auto-format = true

      #  [[language]]
      #  name = "tsx"
      #  language-servers = [ "typescript-language-server", "tailwindcss-react", "eslint", "emmet-language-server"]
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "typescript"] }
      #  auto-format = true

      #  [[language]]
      #  name = "jsx"
      #  language-servers = [ "typescript-language-server", "tailwindcss-react", "eslint"]
      #  grammar = "javascript"
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "typescript"] }
      #  auto-format = true

      #  [[language]]
      #  name = "javascript"
      #  language-servers = [ "typescript-language-server", "tailwindcss-react", "eslint"]
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "typescript"] }
      #  auto-format = true

      #  [[language]]
      #  name = "json"
      #  language-servers = [ "vscode-json-language-server" ]
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "json"] }
      #  auto-format = true

      #  [language-server.vscode-json-language-server.config]
      #  json = { validate = { enable = true }, format = { enable = true } }
      #  provideFormatter = true

      #  [language-server.vscode-css-language-server.config]
      #  css = { validate = { enable = true } }
      #  scss = { validate = { enable = true } }
      #  less = { validate = { enable = true } }
      #  provideFormatter = true

      #  [[language]]
      #  name = "html"
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "html"] }
      #  language-servers = [ "vscode-html-language-server", "tailwindcss-react","emmet-language-server"]
 
      #  [[language]]
      #  name = "css"
      #  formatter = { command = 'npx', args = ["prettier", "--parser", "css"] }
      #  language-servers = [ "vscode-css-language-server", "tailwindcss-react"]

      #  [language-server.emmet-language-server]
      #  command="emmet-language-server"
      #  args = ["--stdio"]


      #  [language-server.tailwindcss-react]
      #  language-id = "typescriptreact"
      #  command = "tailwindcss-language-server"
      #  args = ["--stdio"]
      #  config = {}

  inherit languageServers;
}
