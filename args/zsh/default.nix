{ zshPure
, ...
}:
{
  enable = true;
  enableAutosuggestions = true;
  enableVteIntegration = true;
  autocd = true;
  syntaxHighlighting.enable = true;
  # Group-writable store trips compinit security checks
  #completionInit = "autoload -U compinit && compinit -u";
  shellAliases = {
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

    # Ceramic Pocket Knife
    if [ -e /home/m0ar/.cargo/bin/cpk ]; then
      source <(cpk completion zsh)
    fi
  '' + builtins.readFile ./nvm.zsh;
}
