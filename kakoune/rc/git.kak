## Git diff stuff
# enable flag-lines hl for git diff
hook global WinCreate .* %{
    add-highlighter window/git-diff flag-lines Default git_diff_flags
}

# trigger update diff if inside git dir
hook global BufOpenFile .* %{
  evaluate-commands -draft %sh{
    cd $(dirname "$kak_buffile")
    if [ $(git rev-parse --git-dir 2>/dev/null) ]; then
      for hook in WinCreate BufReload BufWritePost; do
        printf "hook buffer -group git-update-diff %s .* 'git update-diff'\n" "$hook"
      done
    fi
  }
}

