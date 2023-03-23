{ zshPure
, ...
}:
{
  enable = true;
  enableSyntaxHighlighting = true;
  enableAutosuggestions = true;
  enableVteIntegration = true;
  autocd = true;
  # Group-writable store trips compinit security checks
  completionInit = "autoload -U compinit && compinit -u";
  shellAliases = {
    evl = "EVL_HOME=$(git root) nix run evl#evl --";
    cp = "cp -i";
    ls = "ls --color=auto";
    nix = "noglob nix"; # makes flake URI play nice
    ip = "ip --color=auto";
  };
  envExtra = builtins.readFile ./env.zsh;
  profileExtra = builtins.readFile ./profile.zsh;
  initExtra = builtins.readFile ./init.zsh + ''
    fpath+=(${zshPure})
    autoload -U promptinit; promptinit
    prompt pure

    # Append nortical config
    if [[ -e ~/.zshrc_nortical ]]; then
      source ~/.zshrc_nortical
    fi
  '';
}
