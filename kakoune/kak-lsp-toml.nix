{ pkgs
, ...
}:
  ''
  snippet_support = false
  verbosity = 2

  [server]
  # exit session if no requests were received during given period in seconds
  # works only in unix sockets mode (-s/--session)
  # set to 0 to disable
  timeout = 1800 # seconds = 30 minutes

  [language.bash]
  filetypes = ["sh"]
  roots = [".git", ".hg"]
  command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server"
  args = ["start"]

  [language.elixir]
  filetypes = ["elixir"]
  roots = ["mix.exs"]
  command = "${pkgs.elixir_ls}/bin/elixir-ls"
  settings_section = "elixirLS"
  [language.elixir.settings.elixirLS]
  # See https://github.com/elixir-lsp/elixir-ls/blob/master/apps/language_server/lib/language_server/server.ex
  # dialyzerEnable = true

  [language.elm]
  filetypes = ["elm"]
  roots = ["elm.json"]
  command = "${pkgs.elmPackages.elm-language-server}/bin/elm-language-server"
  args = ["--stdio"]
  settings_section = "elmLS"
  [language.elm.settings.elmLS]
  # See https://github.com/elm-tooling/elm-language-server#server-settings
  runtime = "node"
  elmFormatPath = "elm-format"
  elmTestPath = "elm-test"

  [language.erlang]
  filetypes = ["erlang"]
  # See https://github.com/erlang-ls/erlang_ls.git for more information and
  # how to configure. This default config should work in most cases though.
  roots = ["rebar.config", "erlang.mk", ".git", ".hg"]
  command = "${pkgs.erlang-ls}/bin/erlang_ls"

  [language.go]
  filetypes = ["go"]
  roots = ["Gopkg.toml", "go.mod", ".git", ".hg"]
  command = "${pkgs.gopls}/bin/gopls"
  settings_section = "gopls"
  [language.go.settings.gopls]
  # See https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  # "build.buildFlags" = []

  [language.javascript]
  filetypes = ["javascript"]
  roots = ["package.json"]
  command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"
  args = ["--stdio"]

  [language.json]
  filetypes = ["json"]
  roots = ["package.json"]
  command = "${pkgs.nodePackages.vscode-json-languageserver-bin}/bin/json-languageserver"
  args = ["--stdio"]

  [language.nix]
  filetypes = ["nix"]
  roots = ["flake.nix", "shell.nix", ".git", ".hg"]
  command = "${pkgs.nil}/bin/nil"

  [language.python]
  filetypes = ["python"]
  roots = ["requirements.txt", "setup.py", ".git", ".hg"]
  command = "${pkgs.python-language-server}/bin/python-language-server"
  settings_section = "_"
  [language.python.settings._]
  # See https://github.com/python-lsp/python-lsp-server#configuration
  # pylsp.configurationSources = ["flake8"]

  [language.terraform]
  filetypes = ["terraform"]
  roots = ["*.tf"]
  command = "${pkgs.terraform-ls}/bin/terraform-ls"
  args = ["serve"]
  [language.terraform.settings.terraform-ls]
  # See https://github.com/hashicorp/terraform-ls/blob/main/docs/SETTINGS.md
  # rootModulePaths = []

  [language.typescript]
  filetypes = ["typescript"]
  roots = ["package.json", "tsconfig.json", ".git", ".hg"]
  command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"
  args = ["--stdio"]

  [language.yaml]
  filetypes = ["yaml"]
  roots = [".git", ".hg"]
  command = "${pkgs.nodePackages.yaml-language-server}/bin/yaml-language-server"
  args = ["--stdio"]
  [language.yaml.settings]
  # See https://github.com/redhat-developer/yaml-language-server#language-server-settings
  # Defaults are at https://github.com/redhat-developer/yaml-language-server/blob/master/src/yamlSettings.ts
  # yaml.format.enable = true
  ''