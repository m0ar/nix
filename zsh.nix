{ zshPure }:
{
  enable = true;
  enableSyntaxHighlighting = true;
  enableAutosuggestions = true;
  enableVteIntegration = true;
  shellAliases = {
    evl = "EVL_HOME=$(git root) nix run evl#evl --";
    cp = "cp -i";
    ls = "ls --color=auto";
    nix = "noglob nix"; # makes flake URI play nice
    ip = "ip --color=auto";
  };
  envExtra = ''
    export EDITOR=kak
  '';
  initExtra = ''
    setopt extendedglob
    setopt nocaseglob
    setopt appendhistory
    # Navigate words with ctrl+arrow keys
    bindkey '^[Oc' forward-word
    bindkey '^[Od' backward-word
    bindkey '^[[1;5D' backward-word
    bindkey '^[[1;5C' forward-word
    bindkey '^H' backward-kill-word
    bindkey '^[[Z' undo

    # Color man pages
    export LESS_TERMCAP_mb=$'\E[01;32m'
    export LESS_TERMCAP_md=$'\E[01;32m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;47;34m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;36m'
    export LESS=-R

    export PATH=/home/m0ar/.mix/escripts:$PATH
    export PATH=/home/m0ar/go/bin:$PATH
    export PATH=/home/m0ar/.ghcup/bin:$PATH
    export PATH=/home/m0ar/scripts:$PATH
    # Remove dupes
    typeset -U PATH

    if [ -e /home/m0ar/.nix-profile/etc/profile.d/nix.sh ]; then
      . /home/m0ar/.nix-profile/etc/profile.d/nix.sh
    fi

    fpath+=(${zshPure})
    autoload -U promptinit; promptinit
    prompt pure
  '';
}
