setopt extendedglob
setopt nocaseglob
setopt appendhistory
unsetopt sharehistory
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

export PATH=/home/m0ar/.cargo/bin:$PATH
export PATH=/home/m0ar/go/bin:$PATH
export PATH=/home/m0ar/scripts:$PATH
# Remove dupes
typeset -U PATH

if [ -e /home/m0ar/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/m0ar/.nix-profile/etc/profile.d/nix.sh
fi

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
