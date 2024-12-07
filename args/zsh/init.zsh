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

export PATH=/home/m0ar/go/bin:$PATH
export PATH=/home/m0ar/.cargo/bin:$PATH
export PATH=/home/m0ar/scripts:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# export PATH=/usr/lib/jvm/default/bin:$PATH

# Remove dupes
typeset -U PATH

[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

export function ipfsCidToDsKey () {
  ipfs cid format -b base32upper -f '%M' $1
}

export function ipfsDsKeyToCid () {
  ipfs cid format -v1 "B$1" | tr '[:upper:]' '[:lower:]'
}

if command -v fnm > /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
