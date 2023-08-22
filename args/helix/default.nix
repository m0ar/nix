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
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        }; 
        lsp = {
          display-messages = true;
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
    elmPackages.elm-language-server
    python39Packages.python-lsp-server
  ] ++ (with nodePackages; [
    typescript-language-server
    vscode-json-languageserver-bin
    bash-language-server
    yaml-language-server
    dockerfile-language-server-nodejs
  ]);
}