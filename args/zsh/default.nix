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
  completionInit = "autoload -U compinit && compinit -u";
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

    [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
      source /usr/share/nvm/nvm.sh
      source /usr/share/nvm/bash_completion
      source /usr/share/nvm/install-nvm-exec

    # Ceramic Pocket Knife
    if [ -e /home/m0ar/.cargo/bin/cpk ]; then
      source <(cpk completion zsh)
    fi
  '';
}
