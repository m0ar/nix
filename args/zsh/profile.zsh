# Add SSH key to agent if not already present
if [ -n "$SSH_AUTH_SOCK" ] && ! ssh-add -l &>/dev/null; then
  ssh-add -q ~/.ssh/id_rsa 2>/dev/null
fi

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi
