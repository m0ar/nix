{ zshPure
, ...
}:
{
  enable = true;
  autosuggestion.enable = true;
  enableVteIntegration = true;
  autocd = true;
  syntaxHighlighting.enable = true;
  # Group-writable store trips compinit security checks
  #completionInit = "autoload -U compinit && compinit -u";
  shellAliases = {
    # If alias replacement ends with a space, alias expansion is enabled on the following word
    sudo = "sudo --preserve-env=PATH,TERMINFO env ";
    cp = "cp -i";
    ls = "ls --color=auto";
    nix = "noglob nix"; # nomatch handler doesn't like flake URIs
    curl = "noglob curl"; # nomatch handler doesn't like query params
    ip = "ip --color=auto";
    nvm = "fnm";
    kubectl = "kubecolor";
    zshprofile = "time ZSH_DEBUGRC=1 zsh -i -c exit";
    #Search repos with 'paru' and 'fzf'
    parus = "paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S";
    #Search locally installed packages with 'paru', 'fzf' and 'bat'
    parup = "paru -Qq | fzf --preview 'paru -Qil {}' --layout=reverse --bind 'enter:execute(paru -Qil {} | bat)'";

  };
  completionInit = ''
    # AWS autocomplete relies on bash completion being present
    autoload bashcompinit
    bashcompinit

    autoload -Uz compinit
    compinit

    if command -v aws > /dev/null; then
      complete -C "/usr/bin/aws_completer" aws
    fi

    if command -v fnm > /dev/null; then
      source <(fnm completions --shell zsh)
    fi

    if command -v ipfs > /dev/null; then
      source <(ipfs commands completion zsh)
    fi

    if command -v kubecolor > /dev/null; then
      compdef kubecolor=kubectl
    fi

    if command -v vault > /dev/null; then
      complete -C /usr/bin/vault vault
    fi

    if command -v cpk > /dev/null; then
      source <(cpk completion zsh)
    fi
  '';
  envExtra = builtins.readFile ./env.zsh;
  profileExtra = builtins.readFile ./profile.zsh;
  initExtraFirst = ''
    if [ -n "$ZSH_DEBUGRC" ]; then
      zmodload zsh/zprof
    fi
  '';
  initExtra = builtins.readFile ./init.zsh + ''
    fpath+=(${zshPure})
    autoload -U promptinit; promptinit
    prompt pure
    zstyle :prompt:pure:prompt:success color "#ff6ac1"
    zstyle :prompt:pure:prompt:error color "#be5046"
    zstyle :prompt:pure:git:stash show yes

    if [ -n "$ZSH_DEBUGRC" ]; then
      zprof
    fi
  ''; #+ builtins.readFile ./nvm.zsh;
}
